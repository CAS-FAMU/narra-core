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
    class Audio < Narra::SPI::Transcoder

      # Set title and description fields
      @identifier = :audio
      @title = 'Audio Transcoder'
      @description = 'Audio Transcoder based on ffmpeg'

      def self.valid?(item_to_check)
        item_to_check.type.equal?(:video) || item_to_check.type.equal?(:audio)
      end

      def transcode(progress_from, progress_to)
        begin
          # set start progress
          set_progress(progress_from)

          # set up transcode options
          @proxy = transcode_object

          # start transcode process
          @raw.transcode(@proxy[:file], @proxy[:options]) { |progress| set_progress(progress_from + (progress * (progress_to - progress_from)).to_f) }

          # save into storage
          proxy_url = @item.create_file(@proxy[:key], File.open(@proxy[:file])).public_url

          # add proxy files metadata
          add_meta(generator: :transcoder, name: 'audio_proxy', content: proxy_url)
        rescue => e
          #clean
          clean
          # raise exception
          raise e
        else
          # set end progress
          set_progress(progress_to)
          #clean
          clean
        end
      end

      def clean
        # clean temp transcodes
        FileUtils.rm_f([@proxy[:file], @proxy[:file]])
      end

      def transcode_object
        {
            file: Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_audio_proxy.' + Narra::Tools::Settings.audio_proxy_extension,
            key: 'audio_proxy.' + Narra::Tools::Settings.audio_proxy_extension,
            options: {audio_bitrate: Narra::Tools::Settings.audio_proxy_bitrate, custom: '-vn'}
        }
      end
    end
  end
end