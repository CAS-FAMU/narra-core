#
# Copyright (C) 2014 CAS / FAMU
#
# This file is part of Narra Core.
#
# Narra Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@marigan.net>
#

require 'streamio-ffmpeg'
require 'open-uri'

module Narra
  module Workers
    class Transcoder
      include Sidekiq::Worker
      include Narra::Extensions::Progress

      sidekiq_options :queue => :transcodes

      def perform(options)
        # check
        return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?
        # get event
        event = Event.find(options['event'])
        # set event id for Progress extension
        @event_id = options['event']
        # get item
        item = Item.find(options['item'])
        # fire event
        event.run!
        # transcode
        begin
          # temp path
          raw = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_raw'
          # download
          File.open(raw, 'wb') do |file|
            file.write open(options['identifier']).read
          end
          # get video
          video = FFMPEG::Movie.new(raw)
          # process results if valid
          if video.valid?
            # TRANSCODING
            # set up transcode options
            options_lq = {video_bitrate: Narra::Tools::Settings.video_proxy_lq_bitrate, video_bitrate_tolerance: 100, resolution: Narra::Tools::Settings.video_proxy_lq_resolution}
            options_hq = {video_bitrate: Narra::Tools::Settings.video_proxy_hq_bitrate, video_bitrate_tolerance: 100, resolution: Narra::Tools::Settings.video_proxy_hq_resolution}
            # prepare output temp files
            proxy_lq = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_video_proxy_lq.' + Narra::Tools::Settings.video_proxy_extension
            proxy_hq = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_video_proxy_hq.' + Narra::Tools::Settings.video_proxy_extension
            # start transcode process
            video.transcode(proxy_lq, options_lq) { |progress| set_progress(Float(progress / 3)) }
            video.transcode(proxy_hq, options_hq) { |progress| set_progress(Float(0.35 + (progress / 2))) }
            # save into storage
            item.storage.files.create(key: item._id.to_s + '_proxy_lq.' + Narra::Tools::Settings.video_proxy_extension, body: File.open(proxy_lq), public: true)
            item.storage.files.create(key: item._id.to_s + '_proxy_hq.' + Narra::Tools::Settings.video_proxy_extension, body: File.open(proxy_hq), public: true)
            # clean temp transcodes
            FileUtils.rm_f(proxy_lq)
            FileUtils.rm_f(proxy_hq)

            # THUMBNAILS
            # create temp files
            thumb01 = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_thumbnail_01'
            thumb02 = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_thumbnail_02'
            thumb03 = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_thumbnail_03'
            # create screenshots
            video.screenshot(thumb01, {seek_time: 1.0, resolution: Narra::Tools::Settings.thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)
            video.screenshot(thumb02, {seek_time: (video.duration / 2), resolution: Narra::Tools::Settings.thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)
            video.screenshot(thumb03, {seek_time: (video.duration - 1), resolution: Narra::Tools::Settings.thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)
            # uplad thumbnails to storages
            thumb01_storage = item.storage.files.create(key: item._id.to_s + '_thumbnail_01.png', body: File.open(thumb01), public: true)
            thumb02_storage = item.storage.files.create(key: item._id.to_s + '_thumbnail_02.png', body: File.open(thumb02), public: true)
            thumb03_storage = item.storage.files.create(key: item._id.to_s + '_thumbnail_03.png', body: File.open(thumb03), public: true)
            # store meta
            item.meta << Meta.new({generator: :source, name: 'thumbnail_01', content: thumb01_storage.public_url})
            item.meta << Meta.new({generator: :source, name: 'thumbnail_02', content: thumb02_storage.public_url})
            item.meta << Meta.new({generator: :source, name: 'thumbnail_03', content: thumb03_storage.public_url})
            # clean temp
            FileUtils.rm_f(thumb01)
            FileUtils.rm_f(thumb02)
            FileUtils.rm_f(thumb03)
            # set progress
            set_progress(0.95)

            # VIDEOINFO
            # add videoinfo metadata
            item.meta << Meta.new({generator: :source, name: 'duration', content: video.duration})
            item.meta << Meta.new({generator: :source, name: 'bitrate', content: video.bitrate})
            item.meta << Meta.new({generator: :source, name: 'size', content: video.size})
            item.meta << Meta.new({generator: :source, name: 'video_codec', content: video.video_codec})
            item.meta << Meta.new({generator: :source, name: 'colorspace', content: video.colorspace})
            item.meta << Meta.new({generator: :source, name: 'resolution', content: video.resolution})
            item.meta << Meta.new({generator: :source, name: 'width', content: video.width})
            item.meta << Meta.new({generator: :source, name: 'height', content: video.height})
            item.meta << Meta.new({generator: :source, name: 'frame_rate', content: video.frame_rate})
            item.meta << Meta.new({generator: :source, name: 'audio_codec', content: video.audio_codec})
            item.meta << Meta.new({generator: :source, name: 'audio_sample_rate', content: video.audio_sample_rate})
            item.meta << Meta.new({generator: :source, name: 'audio_channels', content: video.audio_channels})
            # set progress
            set_progress(1.0)
          end
          # clean temp file provided by connector
          FileUtils.rm_f(raw)
        rescue
          # nothing to do
          # TODO logging system
        end
        # event done
        event.done!
      end
    end
  end
end