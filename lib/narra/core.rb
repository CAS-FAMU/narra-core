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
  class Core

    # Process invoker
    def self.generate(item, generators = nil)
      # check synthesizers
      generators ||= generators_identifiers
      # select them
      generators.select! {|g| generators_identifiers.include?(g.to_sym)}
      # process item
      process(item: item._id.to_s, identifiers: generators, worker: Narra::Generators::Worker)
    end

    def self.synthesize(item, synthesizers = nil)
      # check synthesizers
      synthesizers ||= synthesizers_identifiers
      # select them
      synthesizers.select! {|s| synthesizers_identifiers.include?(s.to_sym)}
      # process item
      process(item: item._id.to_s, identifiers: synthesizers, worker: Narra::Synthesizers::Worker)
    end

    # Return all active generators
    def self.generators
      # Get all descendants of the Generic generator
      @generators ||= Narra::Generators::Modules::Generic.descendants
    end

    # Return all active synthesizers
    def self.synthesizers
      # Get all descendants of the Generic synthesizer
      @synthesizers ||= Narra::Synthesizers::Modules::Generic.descendants
    end

    private
    def self.process(options)
      # process item
      options[:identifiers].each do |identifier|
        options[:worker].perform_async(options[:item], identifier)
      end
      # return event
      { item: { id: options[:item] }, worker: options[:worker].name, identifiers: options[:identifiers] }
    end

    # Return all active generators
    def self.generators_identifiers
      # Get array of generators identifiers
      @generators_identifiers ||= generators.collect { |generator| generator.identifier }
    end

    # Return all active synthesizers
    def self.synthesizers_identifiers
      # Get array of synthesizers identifiers
      @synthesizers_identifiers ||= synthesizers.collect { |synthesizer| synthesizer.identifier }
    end
  end
end