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
# Authors: Michal Mocnak <michal@marigan.net>
#

require 'narra/extensions'
require 'narra/tools'
require 'narra/spi'
require 'narra/workers'

require 'narra/core/engine'
require 'narra/core/version'

module Narra
  module Core

    # Add item into the NARRA
    def self.add_item(url, author, user, library, metadata = [])
      # input check
      return if url.nil? || author.nil? || user.nil? || library.nil?

      # connector container
      connector = nil

      # parse url for proper connector
      connectors.each do |conn|
        if conn.valid?(url)
          connector = conn.new(url)
          # break the loop
          break
        end
      end

      # check
      return nil if connector.nil?

      # item container
      item = nil

      # recognize type
      case connector.type
        when :video
          # create specific item
          item = Narra::Video.new(name: connector.name, url: url, library: library)
          # push specific metadata
          item.meta << Narra::MetaItem.new(name: 'type', value: :video, generator: :source)
        when :image
          # create specific item
          item = Narra::Image.new(name: connector.name, url: url, library: library)
          # push specific metadata
          item.meta << Narra::MetaItem.new(name: 'type', value: :image, generator: :source)
        when :audio
          # create specific item
          item = Narra::Audio.new(name: connector.name, url: url, library: library)
          # push specific metadata
          item.meta << Narra::MetaItem.new(name: 'type', value: :audio, generator: :source)
      end

      # create source metadata from essential fields
      item.meta << Narra::MetaItem.new(name: 'name', value: connector.name, generator: :source)
      item.meta << Narra::MetaItem.new(name: 'url', value: url, generator: :source)
      item.meta << Narra::MetaItem.new(name: 'library', value: library.name, generator: :source)
      item.meta << Narra::MetaItem.new(name: 'author', value: author, generator: :source)

      # parse metadata from connector if exists
      connector.metadata.each do |meta|
        item.meta << Narra::MetaItem.new(name: meta[:name], value: meta[:value], generator: :source)
      end

      # parse metadata form the user input if exists
      metadata.each do |meta|
        item.meta << Narra::MetaItem.new(name: meta[:name], value: meta[:value], generator: user.username.to_sym)
      end

      # save item
      item.save!

      # start transcode process
      process(type: :transcoder, item: item._id.to_s, identifier: connector.download_url)

      # return item
      return item
    end

    # Generate process invoker
    def self.generate(item, selected_generators = nil)
      # check generators for nil
      selected_generators ||= generators_identifiers
      # select them
      selected_generators.select! { |g| generators_identifiers.include?(g.to_sym) }
      # process item
      selected_generators.each do |generator|
        # get generator class
        check = generators.detect { |g| g.identifier == generator.to_sym }
        # process if it is valid for this item
        process(type: :generator, item: item._id.to_s, identifier: generator) if check.valid?(item)
      end
    end

    # Synthesize process invoker
    def self.synthesize(project, synthesizers = nil)
      # check synthesizers for nil
      synthesizers ||= synthesizers_identifiers
      # select them
      synthesizers.select! { |s| synthesizers_identifiers.include?(s.to_sym) }
      # process item
      synthesizers.each do |synthesizer|
        process(type: :synthesizer, project: project._id.to_s, identifier: synthesizer)
      end
    end

    # Return all active connectors
    def self.connectors
      # Get all descendants of the Generic generator
      @connectors ||= Narra::SPI::Connector.descendants
    end

    # Return all active transcoders
    def self.transcoders
      # Get all descendants of the Generic generator
      @transcoders ||= Narra::SPI::Transcoder.descendants
    end

    # Return all active generators
    def self.generators
      # Get all descendants of the Generic generator
      @generators ||= Narra::SPI::Generator.descendants
    end

    # Return all active synthesizers
    def self.synthesizers
      # Get all descendants of the Generic synthesizer
      @synthesizers ||= Narra::SPI::Synthesizer.descendants
    end

    private

    def self.process(options)
      # setup message
      message = 'narra::' + options[:type].to_s + '::'
      message += options[:item] unless options[:item].nil?
      message += options[:project] unless options[:project].nil?
      message += '::' + options[:identifier].to_s unless options[:type] == :transcoder
      # create an event
      event = Narra::Event.create(message: message,
                           item: options[:item].nil? ? nil : Narra::Item.find(options[:item]),
                           project: options[:project].nil? ? nil : Narra::Project.find(options[:project]),
                           broadcasts: ['narra_' + options[:type].to_s + '_done'])

      # process
      case options[:type]
        when :transcoder
          Narra::Workers::Transcoder.perform_async(options.merge({event: event._id.to_s}))
        when :generator
          Narra::Workers::Generator.perform_async(options.merge({event: event._id.to_s}))
        when :synthesizer
          Narra::Workers::Synthesizer.perform_async(options.merge({event: event._id.to_s}))
      end
      # return event
      return event
    end

    # Return all active synthesizers
    def self.connectors_identifiers
      # Get array of synthesizers identifiers
      @connectors_identifiers ||= connectors.collect { |connector| connector.identifier }
    end

    # Return all active transcoders
    def self.transcoders_identifiers
      # Get array of synthesizers identifiers
      @transcoders_identifiers ||= transcoders.collect { |transcoder| transcoder.identifier }
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