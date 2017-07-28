#
# Copyright (C) 2017 CAS / FAMU
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
  module Defaults
    class Scenario < Narra::SPI::Default

      # Default values
      @identifier = :scenario

      def self.listeners
        [
            {
                instance: Narra::Defaults::Scenario.new,
                event: :narra_user_admin_created
            }
        ]
      end

      def narra_user_admin_created(options)
        # create default library and project scenarios
        # only when the first user is created as admin
        # this user become the author of these
        create_default_library_scenarios(options)
        create_default_project_scenarios(options)
      end

      private

      def create_default_project_scenarios(options)

      end

      def create_default_library_scenarios(options)

      end
    end
  end
end