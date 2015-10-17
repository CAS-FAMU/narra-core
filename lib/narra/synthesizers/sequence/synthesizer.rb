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

require 'narra/synthesizers/sequence/listener'

module Narra
  module Synthesizers
    module Sequence
      class Synthesizer < Narra::SPI::Synthesizer

        # Default values
        @identifier = :sequence
        @title = 'Sequence Synthesizer'
        @description = 'Narra Synthesizer based on project sequences'

        def self.valid?(project_to_check)
          true
        end

        def synthesize(options = {})
          # input check
          sequences = [Narra::Sequence.find(options['sequence'])] unless options['sequence'].nil?
          # check generators for nil and assign only possible generators
          sequences ||= @project.sequences
          # iterate through and resolve
          sequences.each do |sequence|
            # check if the sequence is unprocessed
            junctions = Narra::Junction.where(project: @project, synthesizer: :sequence).any_in(sources: [sequence._id.to_s])
            # process sequence if not processed
            if junctions.empty?
              # order marks
              marks = sequence.marks.order_by(:row => 'asc')
              # iterate
              marks.each_with_index do |mark, index|
                # add junction
                if index+1 != marks.count && (mark.row+1 == marks[index+1].row)
                  # get items
                  from = Narra::Item.find_by(name: mark.clip.name)
                  to = Narra::Item.find_by(name: marks[index+1].clip.name)
                  direction = {from: from._id.to_s, to: to._id.to_s}
                  weight = 0.0
                  # if the connection is between same clips do not add junction
                  unless from.eql?(to)
                    # check if the junction already exists
                    cached = get_junction([from, to], :sequence, direction)
                    weight = cached.weight + 0.1 unless cached.nil?
                    # add junction
                    add_junction([from, to], direction: direction, weight: weight, synthesizer: :sequence, source: sequence._id.to_s)
                  end
                end
              end
            end
          end
        end

        def self.listeners
          [
              {
                  instance: Narra::Synthesizers::Sequence::Listener.new,
                  event: :narra_sequence_destroyed
              },
              {
                  instance: Narra::Synthesizers::Sequence::Listener.new,
                  event: :narra_sequence_created
              },
          ]
        end
      end
    end
  end
end