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
require 'narra/tools'
require 'narra/transcoders/media_info'
require 'narra/transcoders/media_thumbnails'

module Narra
  module Transcoders
    module Media
      extend ActiveSupport::Concern

      include Wisper::Publisher
      include Narra::Tools::Logger
      include Narra::Transcoders::MediaInfo
      include Narra::Transcoders::MediaThumbnails

      module ClassMethods
        def transcode_video(target_format, options={})
          process transcode_video: [target_format, options]
        end

        def transcode_audio(target_format, options={})
          process transcode_audio: [target_format, options]
        end
      end

      def transcode_video(format, options={})
        @format = format
        @options = Narra::Tools::FfmpegOptions.new(format, options)

        manipulate! do |movie, temporary, success|
          if options[:videoinfo]
            # save videoinfo if requested
            info_video(movie)
          end

          if options[:thumbnails]
            # save thumbnails if requested
            thumbnails(movie)
          end

          # transcode movie
          movie.transcode(temporary, @options.format_params, @options.encoder_options) do |progress|
            # broadcast progress value
            broadcast(:narra_transcoder_progress_changed, {progress: progress, type: options[:type]})
          end

          # set flag
          success = true
        end
      end

      def transcode_audio(format, options={})
        @format = format
        @options = Narra::Tools::FfmpegOptions.new(format, options)

        manipulate! do |movie, temporary, success|
          unless movie.audio_stream.nil?
            if options[:videoinfo]
              # save videoinfo if requested
              info_audio(movie)
            end

            # transcode movie
            movie.transcode(temporary, @options.format_params, @options.encoder_options) do |progress|
              # broadcast progress value
              broadcast(:narra_transcoder_progress_changed, {progress: progress, type: options[:type]})
            end

            # set flag
            success = true
          end
        end
      end

      def manipulate!
        cache_stored_file! if !cached?
        movie = ::FFMPEG::Movie.new(current_path)
        temporary = File.join(File.dirname(current_path), "temporary.#{@format}")

        begin
          yield(movie, temporary, success=false)

          # check the output and rename the file
          if success
            # rename encoded file
            File.rename temporary, current_path

            # if there is a different format rename file
            if @format
              # renaming file
              move_to = current_path.chomp(File.extname(current_path)) + ".#{@format}"
              file.move_to(move_to, permissions, directory_permissions)
            end
          end
        rescue => e
          log_error('transcoder#media') {e.message}
          log_error('transcoder#media') {e.backtrace.join("\n")}
        end
      end

      def autosave
        false
      end
    end
  end
end