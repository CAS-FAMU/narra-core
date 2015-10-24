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
        parsed = ::EDL::Parser.new(fps=options['sequence_fps'].to_f).parse(options['sequence_content'])

        # deafult sequence start
        sequence_start = Timecode.parse('00:00:00:00')

        # iterate through and resolve
        parsed.each do |clip|
          # if clip is the first store timecode start of the sequence
          if clip.num.to_i == 1
            sequence_start = Timecode.parse(clip.rec_start_tc.to_s, @sequence.fps)
          end

          # parse and check clip names
          clip_name = clip.clip_name.split('.')[0].downcase
          # prepare marks to create sequence
          @sequence.marks << process_mark(clip: clip_name, row: clip.num.to_i, in: Timecode.parse(clip.src_start_tc.to_s, @sequence.fps), out: Timecode.parse(clip.src_end_tc.to_s, @sequence.fps))
        end

        # chek sequence end timecode
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