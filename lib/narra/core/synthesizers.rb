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
    module Synthesizers

      # Return all active synthesizers
      def Core.synthesizers
        # Get all descendants of the Generic synthesizer
        @synthesizers ||= Narra::SPI::Synthesizer.descendants.sort {|x,y| x.priority.to_i <=> y.priority.to_i }
      end

      # Return specified synthesizer
      def Core.synthesizer(identifier)
        synthesizers.select { |synthesizer| synthesizer.identifier.equal?(identifier.to_sym)}.first
      end

      # Synthesize process invoker
      def Core.synthesize(project, selected_synthesizers = nil, options = {})
        # check synthesizers for nil
        selected_synthesizers ||= synthesizers_identifiers
        # select them
        selected_synthesizers.select! { |s| Synthesizers.synthesizers_identifiers.include?(s.to_sym) }
        # process item
        selected_synthesizers.each do |synthesizer|
          process({type: :synthesizer, project: project._id.to_s, identifier: synthesizer}.merge(options))
        end
      end

      private

      # Return all active synthesizers
      def self.synthesizers_identifiers
        # Get array of synthesizers identifiers
        @synthesizers_identifiers ||= Core.synthesizers.collect { |synthesizer| synthesizer.identifier }
      end
    end
  end
end