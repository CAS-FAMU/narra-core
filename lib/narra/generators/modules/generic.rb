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

module Narra
  module Generators
    module Modules
      # Generic template for generators
      class Generic
        include Narra::Tools::Class

        # Attributes for human readable format
        # These have to be imlemented in descendants
        class << self
          attr_accessor :identifier, :title, :description
        end

        # Default values
        @identifier = :generic
        @title = 'Generic'
        @description = 'Generic Generator'

        # Generic constructor to store an item to be processed
        def initialize(item)
          @item = item
        end

        def add_meta(options)
          # push new meta entry
          @item.meta << Meta.new({provider: self.class.identifier}.merge(options))
          # save item
          @item.save
        end

        # Generic generate method
        def generate
          # Nothing to do
          # This has to be overridden in descendants
        end
      end
    end
  end
end