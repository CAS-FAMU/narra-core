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
    module Generators

      # Return all active generators
      def Core.generators
        # Get all descendants of the Generic generator
        @generators ||= Narra::SPI::Generator.descendants.sort { |x, y| x.priority.to_i <=> y.priority.to_i }
      end

      # Return specified generator
      def Core.generator(identifier)
        generators.select { |generator| generator.identifier.equal?(identifier.to_sym) }.first
      end

      # Generate process invoker
      def Core.generate(item, selected_generators = nil, options = {})
        # check generators for nil and assign only possible generators
        selected_generators ||= item.library.generators.map { |g| g[:identifier].to_s }
        # select them
        selected_generators.select! { |g|
          item.library.scenario.generators.map { |h| h[:identifier].to_s }.include?(g.to_s) &&
              Generators.generators_identifiers.include?(g.to_sym)
        }
        # collect
        selected_generators.collect! { |g| item.library.scenario.generators.detect { |h| h[:identifier].to_s == g.to_s} }
        # process item
        selected_generators.each do |generator|
          # get generator class
          check = generators.detect { |g| g.identifier == generator[:identifier].to_sym }
          # process if it is valid for this item
          process(type: :generator, item: item._id.to_s, identifier: generator[:identifier], options: generator[:options].merge(options)) if check.valid?(item)
        end
      end

      private

      # Return all active generators
      def self.generators_identifiers
        # Get array of generators identifiers
        @generators_identifiers ||= Core.generators.collect { |generator| generator.identifier }
      end

    end
  end
end