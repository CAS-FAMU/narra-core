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

      def url_thumbnail
        @url_thumbnails.first unless thumbnails.nil?
      end

      def url_thumbnails
        # get thumbnail if not resolved yet
        @url_thumbnails ||= Narra::Meta.any_in(item_id: self.items.collect { |item| item._id }).where(generator: :thumbnail).sample(Narra::Tools::Settings.thumbnail_count.to_i).collect { |meta| meta.content }
      end
    end
  end
end