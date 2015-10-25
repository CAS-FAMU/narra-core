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
  module Synthesizers
    module Sequence
      class Listener

        def narra_sequence_destroyed(options)
          # input check
          return if options[:project].nil? || options[:sequence].nil?
          # get project
          project = Narra::Project.find_by(name: options[:project])
          # get affected junctions
          junctions = Narra::Junction.any_in(sources: [options[:sequence]]).where(project: project, synthesizer: :sequence)
          # process
          junctions.each do |junction|
            # get sources
            sources = junction.sources
            # calculate appearances
            counts = sources.each_with_object(Hash.new(0)) { |source,counts| counts[source] += 1 }
            # process
            if counts.keys.count == 1
              # destroy junction if there is only one exact source
              junction.destroy
            else
              # if there are more sources just remove the one and decrease the weight
              junction.sources.delete(options[:sequence])
              junction.weight = junction.weight - (0.1 * counts[options[:sequence]])
              junction.save
            end
          end
        end

        def narra_sequence_created(options)
          # input check
          return if options[:project].nil? || options[:sequence].nil?
          # get project
          project = Narra::Project.find_by(name: options[:project])
          # submit synthesize process
          Narra::Project.synthesize(project, :sequence, {sequence: options[:sequence]})
        end
      end
    end
  end
end