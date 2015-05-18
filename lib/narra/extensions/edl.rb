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

      def process_edl(options)
        # parse
        parsed = ::EDL::Parser.new(fps=options['edl_fps'].to_i).parse(options['sequence_content'])

        # options and marks
        sequence = {name: options['sequence_name'], author: options['author'], marks: []}

        # iterate through and resolve
        parsed.each do |clip|
          # parse and check clip names
          clip_name = clip.clip_name.split('.')[0].downcase
          # prepare marks to create sequence
          sequence[:marks] << {clip: clip_name, in: clip.src_start_tc.to_s, out: clip.src_end_tc.to_s}
        end

        # get back well formed hash
        return sequence
      end
    end
  end
end