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

module Narra
  module Extensions
    module Thumbnail

      def items
        # This has to be overridden to return item
      end

      def thumbnail
        thumbnails.first unless thumbnails.nil?
      end

      def url_thumbnail
        thumbnail.public_url
      end

      def thumbnails
        # get thumbnail if not resolved yet
        if @thumbnails.nil?
          # get the first item available
          item = self.items.first
          # get all files
          @thumbnails = item.storage.files.select { |file| file.key.include?('thumbnail') } unless item.nil?
        end
        # return thumbnail
        @thumbnails
      end

      def url_thumbnails
        thumbnails.collect { |thumbnail| thumbnail.public_url }
      end
    end
  end
end