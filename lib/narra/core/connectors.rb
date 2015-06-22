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
  module Core
    module Connectors

      # Return all active connectors
      def Core.connectors
        # Get all descendants of the Generic generator
        @connectors ||= Narra::SPI::Connector.descendants
      end

      # Return specified connector
      def Core.connector(identifier)
        connectors.select { |connector| connector.identifier.equal?(identifier.to_sym)}.first
      end

      private

      # Return all active synthesizers
      def self.connectors_identifiers
        # Get array of synthesizers identifiers
        @connectors_identifiers ||= connectors.collect { |connector| connector.identifier }
      end
    end
  end
end
