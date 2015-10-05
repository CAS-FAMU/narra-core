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

require 'narra/extensions'
require 'narra/tools'

module Narra
  module SPI
    # Generic template for generators
    class Generator
      include Narra::Extensions::Class
      include Narra::Extensions::Meta
      include Narra::Extensions::Progress
      include Narra::Extensions::Options
      include Narra::Tools::Logger
      include Narra::Tools::InheritableAttributes

      inheritable_attributes :identifier, :title, :description, :options, :dependency, :priority

      # Default values
      @identifier = :generic
      @title = 'Generic'
      @description = 'Generic Generator'
      @options = {}
      @dependency = []
      @priority = 42

      # Generic constructor to store an item to be processed
      def initialize(item, event)
        @item = item
        @event = event
        # connector specific initialization
        initialization
      end

      def model
        @item
      end

      def event
        @event
      end

      #
      # Should be overridden and implemented
      #

      def self.valid?(item_to_check)
        # Nothing to do
        # This has to be overridden in descendants
      end

      def initialization
        # Nothing to do
        # This has to be overridden in descendants
      end

      def generate(options = {})
        # Nothing to do
        # This has to be overridden in descendants
      end
    end
  end
end