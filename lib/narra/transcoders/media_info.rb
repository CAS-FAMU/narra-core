#
# Copyright (C) 2015 CAS / FAMU
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

module Narra
  module Transcoders
    module MediaInfo
      include Narra::Extensions::Meta

      def info_video(movie)
        # process movie and save meta
        add_meta(generator: :source, name: 'size', value: movie.size)
        add_meta(generator: :source, name: 'duration', value: movie.duration)
        add_meta(generator: :source, name: 'timecode', value: movie.metadata[:timecode]) unless movie.metadata.key?(:timecode)
        add_meta(generator: :source, name: 'bitrate', value: movie.bitrate)
        add_meta(generator: :source, name: 'video_codec', value: movie.video_codec)
        add_meta(generator: :source, name: 'colorspace', value: movie.colorspace)
        add_meta(generator: :source, name: 'resolution', value: movie.resolution)
        add_meta(generator: :source, name: 'width', value: movie.width)
        add_meta(generator: :source, name: 'height', value: movie.height)
        add_meta(generator: :source, name: 'frame_rate', value: movie.frame_rate)
        # if there is audio stream add meta too
        unless movie.audio_stream.nil?
          add_meta(generator: :source, name: 'audio_codec', value: movie.audio_codec)
          add_meta(generator: :source, name: 'audio_sample_rate', value: movie.audio_sample_rate)
          add_meta(generator: :source, name: 'audio_channels', value: movie.audio_channels)
        end
      end

      def info_audio(movie)
        # process audio and save meta
        add_meta(generator: :source, name: 'size', value: movie.size)
        add_meta(generator: :source, name: 'duration', value: movie.duration)
        add_meta(generator: :source, name: 'timecode', value: movie.metadata[:timecode]) unless movie.metadata.key?(:timecode)
        add_meta(generator: :source, name: 'bitrate', value: movie.bitrate)
        add_meta(generator: :source, name: 'audio_codec', value: movie.audio_codec)
        add_meta(generator: :source, name: 'audio_sample_rate', value: movie.audio_sample_rate)
        add_meta(generator: :source, name: 'audio_channels', value: movie.audio_channels)
      end

      def autosave
        false
      end
    end
  end
end