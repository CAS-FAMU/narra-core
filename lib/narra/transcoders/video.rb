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

require 'narra/spi'
require 'streamio-ffmpeg'

module Narra
  module Transcoders
    class Video < Narra::SPI::Transcoder

      # Set title and description fields
      @identifier = :video
      @title = 'Video Transcoder'
      @description = 'Video Transcoder based on ffmpeg'

      def self.valid?(item_to_check)
        item_to_check.type.equal?(:video)
      end

      def transcode(progress_from, progress_to)
        # set start progress
        set_progress(progress_from)

        # set up transcode options
        proxy_lq = transcode_object('lq')
        proxy_hq = transcode_object('hq')

        # calculate progress portion
        progress_lq = (progress_to - progress_from) / 3
        progress_hq = progress_lq * 2

        # start transcode process
        @raw.transcode(proxy_lq[:file], proxy_lq[:options]) { |progress| set_progress(progress_from + (progress * progress_lq).to_f) }
        @raw.transcode(proxy_hq[:file], proxy_hq[:options]) { |progress| set_progress(progress_from + progress_lq + (progress * progress_hq).to_f) }

        # save into storage
        proxy_lq_url = @item.create_file(proxy_lq[:key], File.open(proxy_lq[:file])).public_url
        proxy_hq_url = @item.create_file(proxy_hq[:key], File.open(proxy_hq[:file])).public_url

        # add proxy files metadata
        add_meta(generator: :transcoder, name: 'video_proxy_lq', content: proxy_lq_url)
        add_meta(generator: :transcoder, name: 'video_proxy_hq', content: proxy_hq_url)

        # clean temp transcodes
        FileUtils.rm_f([proxy_lq[:file], proxy_hq[:file]])

        # set end progress
        set_progress(progress_to)
      end

      def transcode_object(type)
        {
            file: Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_video_proxy_' + type + '.' + Narra::Tools::Settings.video_proxy_extension,
            key: 'video_proxy_' + type + '.' + Narra::Tools::Settings.video_proxy_extension,
            options: {video_bitrate: Narra::Tools::Settings.get('video_proxy_' + type + '_bitrate'), video_bitrate_tolerance: 100, resolution: Narra::Tools::Settings.get('video_proxy_' + type + '_resolution')}
        }
      end
    end
  end
end