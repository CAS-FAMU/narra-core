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

module Generators
  module Modules
    # Generic template for generators
    class Generic
      # Generic constructor to store an item to be processed
      def initialize(item)
        @item = item
      end

      # Generator default name to be saved as a part of meta record
      def name
        Tools::Class.class_name_to_sym(self.class)
      end

      # Generic generate method
      def generate
        # Nothing to do
        # This has to be overrided in ancestors
      end

      def self.descendants
        @descendants ||= []
      end

      def self.inherited(descendant)
        descendants << descendant
      end
    end
  end
end