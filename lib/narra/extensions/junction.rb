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
    module Junction

      def project
        # This has to be overridden to return item
      end

      def add_junction(items = [], options)
        # input check
        return if items.empty? || options[:synthesizer].nil? || options[:source].nil? ||
            options[:weight].nil? || !options[:weight].instance_of?(Float) || options[:direction].nil?

        # get junction
        cached = get_junction(items, options[:synthesizer], options[:direction])

        # update already existing or create a new one
        if cached.nil?
          # push new junction entry
          Narra::Junction.create(project: project, items: items, direction: options[:direction], weight: options[:weight], synthesizer: options[:synthesizer], sources: [options[:source]])
        else
          # update junction
          cached.weight = options[:weight]
          cached.sources << options[:source]
          cached.save
        end
      end

      def get_junction(items = [], synthesizer, direction)
        # get junction
        Narra::Junction.any_in(item_ids: items.collect {|item| item._id.to_s}).find_by(project: project, synthesizer: synthesizer, direction: direction)
      end
    end
  end
end