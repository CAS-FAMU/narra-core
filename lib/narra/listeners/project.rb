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
    class Project
      include Narra::Tools::Logger

      def narra_scenario_project_updated(options)
        options[:projects].each do |project_name|
          # get project and changes
          project = Narra::Project.find_by(name: project_name)
          changes = options[:changes]

          # process changes
          unless changes.nil?
            removed = changes - project.synthesizers
            created = project.synthesizers - changes

            # delete all junctions for appropriate synthesizer
            removed.each do |synthesizer|
              project.junctions.where(synthesizer: synthesizer).destroy_all
            end

            # run synthesize process for appropriate synthesizer
            created.each do |synthesizer|
              Narra::Project.synthesize(project, synthesizer[:identifier])
            end

            # log
            log_info('listener#project') {'Project ' + project.name + ' scenario updated.'}
          end
        end
      end
    end
  end
end