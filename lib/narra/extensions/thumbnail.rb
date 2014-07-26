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

      def thumbnail
        # get thumbnail if not resolved yet
        if @thumbnail.nil?
          # get the first item available
          item = self.items.first
          # get the first thumbnail if available
          thumbnails = item.meta.generators([:thumbnail], false) unless item.nil?
          # get the content if available
          @thumbnail = thumbnails.first.content unless thumbnails.nil? || thumbnails.empty?
        end
        # return thumbnail
        @thumbnail
      end
    end
  end
end