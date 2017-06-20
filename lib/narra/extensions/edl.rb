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
# Narra Core is distributed input the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@marigan.net>
#

require 'edl'

module Narra
  module Extensions
    module EDL

      def self.included base
        base.include Narra::Extensions::Mark
        base.include Narra::Extensions::Meta
      end

      def process_edl(options)
        # parse
        parsed = ::EDL::Parser.new(fps=@sequence.fps).parse(options['sequence_content'])

        # deafult marks container
        marks = {}

        # iterate through and resolve
        parsed.each do |clip|
          # prepare clip name
          clip_name = clip.clip_name.nil? ? 'black' : clip.clip_name.split('.')[0].downcase
          # check for missing values
          if marks[clip.num].nil? || marks[clip.num][:clip] == 'black'
            marks[clip.num] = {clip: clip_name, row: clip.num.to_i, input: Timecode.parse(clip.src_start_tc.to_s, @sequence.fps), output: Timecode.parse(clip.src_end_tc.to_s, @sequence.fps)}
          end
        end
        # prepare marks to create sequence
        marks.each_value do |mark|
          @sequence.marks << process_mark(mark)
        end
        # check sequence start timecode
        sequence_start = Timecode.parse(parsed.first.rec_end_tc.to_s, @sequence.fps)
        # check sequence end timecode
        sequence_end = Timecode.parse(parsed.last.rec_end_tc.to_s, @sequence.fps)
        # sequence duration
        duration = ((sequence_end - sequence_start).to_f / @sequence.fps).to_f
        # store metadata
        add_meta(name: 'timecode', value: sequence_start.to_s)
        add_meta(name: 'duration', value: duration.to_s)
      end
    end
  end
end