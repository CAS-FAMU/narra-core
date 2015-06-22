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

module Narra
  module Extensions
    module MetaSequence
      include Narra::Extensions::Meta

      def sequence
        # This has to be overridden to return project
      end

      def add_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # push meta into a project
        sequence.meta << Narra::MetaSequence.new(options)
        # save item
        sequence.save
      end

      def update_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # retrieve meta
        meta = get_meta(name: options[:name])
        # if not null update
        meta.update_attributes(value: options[:value])
        # return meta
        meta
      end

      def get_meta(options)
        # do a query
        result = sequence.meta.where(options)
        # check and return
        result.empty? ? nil : (result.count > 1 ? result : result.first)
      end
    end
  end
end