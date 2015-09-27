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

require 'carrierwave/video'

module Narra
  module Transcoders
    module Text
      extend ActiveSupport::Concern

      include Wisper::Publisher
      include Narra::Tools::Logger

      module ClassMethods
        def transcode_text(target_format, options={})
          process transcode_text: [target_format, options]
        end
      end

      def transcode_text(format, options={})
        manipulate! do |movie, temporary|
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
            broadcast(:narra_transcoder_progress_changed, {progress: progress, type: options[:type] })
          end
        end
      end

      def manipulate!
        cache_stored_file! if !cached?
        movie = ::FFMPEG::Movie.new(current_path)
        temporary = File.join(File.dirname(current_path), "temporary.#{@format}")

        begin
          yield(movie, temporary)

          # rename encoded file
          File.rename temporary, current_path

          # if there is a different format rename file
          if @format
            # renaming file
            move_to = current_path.chomp(File.extname(current_path)) + ".#{@format}"
            file.move_to(move_to, permissions, directory_permissions)
          end
        rescue => e
          log_error('transcoder#media') { e.to_s }
        end
      end

      def autosave
        false
      end
    end
  end
end