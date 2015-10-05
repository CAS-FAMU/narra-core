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
  module Extensions
    module Options

      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods
        def parse_options(name, options = {})
          # get value
          value = options[name.to_s].nil? ? self.options[name.to_sym] : options[name.to_s]
          # parse value
          if value.to_s.include?(',')
            # return array value
            return value.split(',').collect { |item| item.strip }
          elsif ['true', 'false'].include?(value.to_s)
            # return boolean value
            return value == 'true'
          end
          # just return value
          return value
        end

        def to_array(value)
          value.kind_of?(Array) ? value : [value].reject { |item| item.empty? }
        end
      end
    end
  end
end