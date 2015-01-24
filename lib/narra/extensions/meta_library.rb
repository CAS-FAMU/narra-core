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
    module MetaLibrary

      def library
        # This has to be overridden to return project
      end

      def add_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # push meta into a project
        library.meta << Narra::MetaLibrary.new(options)
        # save item
        library.save
      end

      def get_meta(options)
        # do a query
        result = library.meta.where(options)
        # check and return
        result.empty? ? nil : (result.count > 1 ? result : result.first)
      end
    end
  end
end