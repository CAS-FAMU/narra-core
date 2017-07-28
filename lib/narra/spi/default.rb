#
# Copyright (C) 2017 CAS / FAMU
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

require 'carrierwave'
require 'narra/extensions'
require 'narra/tools'

module Narra
  module SPI
    # Generic template for storage
    class Default
      include Narra::Extensions::Class
      include Narra::Tools::Logger
      include Narra::Tools::InheritableAttributes

      inheritable_attributes :identifier

      # Default values
      @identifier = :generic

      #
      # Should be overridden and implemented
      #

      def self.settings
        # Nothing to do
        # This has to be overridden in descendants
        # It should return Hash of default settings
        {}
      end

      def self.listeners
        # Nothing to do
        # This can be overridden in descendants
        # It should return array of listener hashes
        # {
        #   instance: Narra::Defaults::Generic::Listener.new,
        #   event: :narra_generic_event
        # }
        []
      end
    end
  end
end