#
# Copyright (C) 2017 CAS / FAMU
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

require 'carrierwave/video'

module Narra
  module Tools
    class FfmpegOptions < CarrierWave::Video::FfmpegOptions

      def format_params
        params = super
        params[:custom] = params[:custom].split
        params
      end

      private

      def defaults
        @defaults ||= {resolution: '640x360', watermark: {}}.tap do |h|
          case format
            when 'mp4'
              h[:video_codec] = 'libx264'
              h[:audio_codec] = 'libfdk_aac'
              h[:custom] = '-qscale 0 -preset slow -g 30'
            when 'ogv'
              h[:video_codec] = 'libtheora'
              h[:audio_codec] = 'libvorbis'
              h[:custom] = '-b 1500k -ab 160000 -g 30'
            when 'webm'
              h[:video_codec] = 'libvpx'
              h[:audio_codec] = 'libvorbis'
              h[:custom] = '-b 1500k -ab 160000 -f webm -g 30'
          end
        end
      end
    end
  end
end