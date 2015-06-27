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
    module MediaThumbnails

      def thumbnails(movie)
        # calculate seek ratio
        ratio = (movie.duration / Integer(Narra::Tools::Settings.thumbnail_count)).to_i

        # generate all thumbnails
        (1..Narra::Tools::Settings.thumbnail_count.to_i).each do |count|
          begin
            # seek
            seek = '%05d' % (((count * ratio) == movie.duration) ? (count * ratio) - 1 : count * ratio)
            # get thumbnail object
            thumbnail = File.join(File.dirname(current_path), "thumbnail_#{seek}.#{Narra::Tools::Settings.thumbnail_extension}")
            # generate
            movie.screenshot(thumbnail, {seek_time: seek.to_i}, validate: false)
            # save thumbnail
            model.thumbnails << Narra::Thumbnail.new(file: File.open(thumbnail))
          ensure
            # delete temp file
            FileUtils.rm_f(thumbnail)
          end
        end
      end
    end
  end
end