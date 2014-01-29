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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

require 'streamio-ffmpeg'
require 'open-uri'

module Narra
  module Generators
    module Modules
      # Videoinfo Generator module
      class Videoinfo < Narra::Generators::Modules::Generic

        # Set title and description fields
        @identifier = :videoinfo
        @title = 'Videoinfo'
        @description = 'Videoinfo Metadata Generator based on FFMPEG'

        def generate
          # temp path
          path = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_videoinfo_video'

          # download
          File.open(path, 'wb') do |file|
            file.write open(@item.url).read
          end

          # prepare ffmpeg client
          video = FFMPEG::Movie.new(path)

          # process results if valid
          if video.valid?
            add_meta(name: 'duration', content: video.duration)
            add_meta(name: 'bitrate', content: video.bitrate)
            add_meta(name: 'size', content: video.size)
            add_meta(name: 'video_codec', content: video.video_codec)
            add_meta(name: 'colorspace', content: video.colorspace)
            add_meta(name: 'resolution', content: video.resolution)
            add_meta(name: 'width', content: video.width)
            add_meta(name: 'height', content: video.height)
            add_meta(name: 'frame_rate', content: video.frame_rate)
            add_meta(name: 'audio_codec', content: video.audio_codec)
            add_meta(name: 'audio_sample_rate', content: video.audio_sample_rate)
            add_meta(name: 'audio_channels', content: video.audio_channels)
          end

          # clean temp
          FileUtils.rm_f(path)
        end
      end
    end
  end
end