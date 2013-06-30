#
# Copyright (C) 2013 CAS / FAMU
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

module API
  module Wrappers
    class Collection

      # Attributes
      attr_accessor :status
      attr_accessor :collection
      attr_accessor :collections

      def initialize(status, collection = nil, collections = nil)
        @status = status
        @collection = collection
        @collections = collections
      end

      def self.collection(collection)
        Collection.new(API::Enums::Status::OK, collection, nil)
      end

      def self.collections(collections)
        Collection.new(API::Enums::Status::OK, nil, collections)
      end
    end
  end
end