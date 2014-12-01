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

require 'sidekiq'
require 'streamio-ffmpeg'
require 'open-uri'

module Narra
  module Workers
    class Transcoder
      include Sidekiq::Worker
      include Narra::Extensions::Progress
      include Narra::Extensions::Meta

      sidekiq_options :queue => :transcodes

      def perform(options)
        # check
        return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?
        # get event
        @event = Narra::Event.find(options['event'])
        # get item
        @item = Narra::Item.find(options['item'])
        @item_id = options['item']
        # fire event
        @event.run!
        # transcode
        begin
          # temp path
          raw = Narra::Tools::Settings.storage_temp + '/' + @item_id + '_raw'
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
            proxy_lq = transcode_object('lq')
            proxy_hq = transcode_object('hq')
            # start transcode process
            video.transcode(proxy_lq[:file], proxy_lq[:options]) { |progress| set_progress((progress / 3).to_f) }
            video.transcode(proxy_hq[:file], proxy_hq[:options]) { |progress| set_progress((0.35 + (progress / 2)).to_f) }
            # save into storage
            proxy_lq_url = @item.create_file(proxy_lq[:key], File.open(proxy_lq[:file])).public_url
            proxy_hq_url = @item.create_file(proxy_hq[:key], File.open(proxy_hq[:file])).public_url
            # add proxy files metadata
            add_meta(generator: :transcoder, name: 'proxy_lq', content: proxy_lq_url)
            add_meta(generator: :transcoder, name: 'proxy_hq', content: proxy_hq_url)
            # clean temp transcodes
            FileUtils.rm_f([proxy_lq[:file], proxy_hq[:file]])

            # THUMBNAILS
            # get seek ration
            ratio = (video.duration / Integer(Narra::Tools::Settings.thumbnail_count)).to_i
            # generate all thumbnails
            (1..Narra::Tools::Settings.thumbnail_count.to_i).each do |count|
              # seek
              seek = '%05d' % (((count * ratio) == video.duration) ? (count * ratio) - 1 : count * ratio)
              # get thumbnail object
              thumbnail = thumbnail_object(seek)
              # generate
              video.screenshot(thumbnail[:file], thumbnail[:options], preserve_aspect_ratio: :height, validate: false)
              # copy to storage
              url = @item.create_file(thumbnail[:key], File.open(thumbnail[:file])).public_url
              # create meta
              add_meta(generator: :thumbnail, name: 'thumbnail_' + seek, content: url, in: seek.to_f)
              # delete
              FileUtils.rm_f(thumbnail[:file])
            end
            # set progress
            set_progress(0.95)

            # VIDEOINFO
            # add videoinfo metadata
            add_meta(generator: :source, name: 'duration', content: video.duration)
            add_meta(generator: :source, name: 'timecode', content: video.timecode) unless video.timecode.nil?
            add_meta(generator: :source, name: 'bitrate', content: video.bitrate)
            add_meta(generator: :source, name: 'size', content: video.size)
            add_meta(generator: :source, name: 'video_codec', content: video.video_codec)
            add_meta(generator: :source, name: 'colorspace', content: video.colorspace)
            add_meta(generator: :source, name: 'resolution', content: video.resolution)
            add_meta(generator: :source, name: 'width', content: video.width)
            add_meta(generator: :source, name: 'height', content: video.height)
            add_meta(generator: :source, name: 'frame_rate', content: video.frame_rate)
            add_meta(generator: :source, name: 'audio_codec', content: video.audio_codec)
            add_meta(generator: :source, name: 'audio_sample_rate', content: video.audio_sample_rate)
            add_meta(generator: :source, name: 'audio_channels', content: video.audio_channels)
            # set progress
            set_progress(1.0)
          end
          # clean temp file provided by connector
          FileUtils.rm_f(raw)
        rescue => e
          # nothing to do
          # TODO logging system
          puts e.backtrace
        end
        # event done
        @event.done!
      end

      def item
        @item
      end

      def event
        @event
      end

      def transcode_object(type)
        {
            file: Narra::Tools::Settings.storage_temp + '/' + @item_id + '_video_proxy_' + type + '.' + Narra::Tools::Settings.video_proxy_extension,
            key: 'proxy_' + type + '.' + Narra::Tools::Settings.video_proxy_extension,
            options: {video_bitrate: Narra::Tools::Settings.get('video_proxy_' + type + '_bitrate'), video_bitrate_tolerance: 100, resolution: Narra::Tools::Settings.get('video_proxy_' + type + '_resolution')}
        }
      end

      def thumbnail_object(seek)
        {
            file: Narra::Tools::Settings.storage_temp + '/' + @item_id + '_video_thumbnail_' + seek,
            key: 'thumbnail_' + seek + '.' + Narra::Tools::Settings.thumbnail_extension,
            options: {seek_time: seek.to_i, resolution: Narra::Tools::Settings.thumbnail_resolution}
        }
      end
    end
  end
end