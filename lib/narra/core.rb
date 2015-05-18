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

require 'narra/core/connectors'
require 'narra/core/generators'
require 'narra/core/synthesizers'
require 'narra/core/transcoders'
require 'narra/core/items'
require 'narra/core/sequences'

module Narra
  module Core
    include Narra::Core::Connectors
    include Narra::Core::Generators
    include Narra::Core::Synthesizers
    include Narra::Core::Transcoders
    include Narra::Core::Items
    include Narra::Core::Sequences

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
        when :sequence
          Narra::Workers::Sequence.perform_async(options.merge({event: event._id.to_s}))
      end
      # return event
      return event
    end
  end
end