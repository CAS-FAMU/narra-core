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
    class InfoVideo < Narra::SPI::Transcoder

      # Set title and description fields
      @identifier = :info_video
      @title = 'Info Video Transcoder'
      @description = 'Info Video Transcoder based on ffmpeg'

      def self.valid?(item_to_check)
        item_to_check.type.equal?(:video)
      end

      def transcode(progress_from, progress_to)
        # set start progress
        set_progress(progress_from)

        # Default for all
        add_meta(generator: :source, name: 'size', value: @raw.size)
        add_meta(generator: :source, name: 'duration', value: @raw.duration)
        add_meta(generator: :source, name: 'timecode', value: @raw.timecode) unless @raw.timecode.nil?
        add_meta(generator: :source, name: 'bitrate', value: @raw.bitrate)
        add_meta(generator: :source, name: 'video_codec', value: @raw.video_codec)
        add_meta(generator: :source, name: 'colorspace', value: @raw.colorspace)
        add_meta(generator: :source, name: 'resolution', value: @raw.resolution)
        add_meta(generator: :source, name: 'width', value: @raw.width)
        add_meta(generator: :source, name: 'height', value: @raw.height)
        add_meta(generator: :source, name: 'frame_rate', value: @raw.frame_rate)
        add_meta(generator: :source, name: 'audio_codec', value: @raw.audio_codec)
        add_meta(generator: :source, name: 'audio_sample_rate', value: @raw.audio_sample_rate)
        add_meta(generator: :source, name: 'audio_channels', value: @raw.audio_channels)

        # set end progress
        set_progress(progress_to)
      end
    end
  end
end