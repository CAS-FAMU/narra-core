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
  module SPI
    # Generic template for synthesizers
    class Synthesizer
      include Narra::Extensions::Class

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
      def initialize(project, event)
        @project = project
        @event = event
      end

      def add_junction(options)
        # input check
        return if options[:out].nil? || options[:weight].nil? || !options[:weight].instance_of?(Float)
        # push new junction entry
        @project.junctions << Junction.new({synthesizer: self.class.identifier, in: @item}.merge(options))
        # save project
        @project.save
      end

      #
      # Should be overridden and implemented
      #

      def synthesize
        # Nothing to do
        # This has to be overridden in descendants
      end
    end
  end
end