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
    module Shared
      extend ActiveSupport::Concern
      include Narra::Extensions::Meta

      included do
        after_create :narra_shared_initialize
      end

      def is_shared?
        # get public meta
        meta = get_meta(name: 'shared')
        # resolve
        meta.nil? ? false : meta.value == 'true'
      end

      def shared=(shared)
        self.update_meta(name: 'shared', value: shared)
      end

      protected

      def narra_shared_initialize
        self.add_meta(name: 'shared', value: false)
      end
    end
  end
end