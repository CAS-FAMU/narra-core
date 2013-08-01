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
  module Synthesizers
    module Modules
      # Generic template for synthesizers
      class Generic
        include Tools::Class

        # Attributes for human readable format
        # These have to be imlemented in descendants
        class << self
          attr_accessor :identifier, :title, :description
        end

        # Default values
        @identifier = :generic
        @title = 'Generic'
        @description = 'Generic Synthesizer'

        # Generic constructor to store an item to be processed
        def initialize(item)
          @item = item
        end

        # Generic synthesize method
        def synthesize
          # Nothing to do
          # This has to be overridden in descendants
        end
      end
    end
  end
end