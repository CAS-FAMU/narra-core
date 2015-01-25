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
  module Listeners
    class Library
      include Narra::Tools::Logger

      def narra_library_generators_updated(options)
        # get library
        library = Narra::Library.find(options[:library])
        # run new generators over all items from the library
        Narra::Item.generate(library.items)
        # log
        log_info('listener#library') { 'Library ' + library.name + '#' + library._id.to_s + 'generators updated.'}
      end
    end
  end
end