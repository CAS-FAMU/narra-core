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

require 'timecode'

module Narra
  module Extensions
    module Mark

      def process_mark(mark)
        # get item
        item = @sequence.project.items.find_by(name: mark[:clip])
        # start_tc
        start_tc = Timecode.parse(item.nil? ? '00:00:00:00' : item.get_meta(name: 'timecode', generator: :source).value, @sequence.fps)
        # calculate timecodes
        src_in = ((mark[:in] - start_tc).to_f / @sequence.fps).to_f
        src_out = ((mark[:out] - start_tc).to_f / @sequence.fps).to_f
        # return mark
        Narra::MarkFlow.new(clip: mark[:clip], row: mark[:row], in: src_in, out: src_out)
      end
    end
  end
end