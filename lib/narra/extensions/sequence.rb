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
    module Sequence

      def add_sequence(options)
        # input check
        return if options[:name].nil? || options[:marks].nil?
        # marks container
        marks = []
        # get author
        author = Narra::User.find(options[:author])
        # prepare events
        options[:marks].each_with_index do |mark, index|
          # get item
          item = Narra::Item.find_by(name: mark[:clip])
          # check
          unless item.nil?
            # start_tc
            start_tc = Timecode.parse(item.get_meta(name: 'timecode', generator: :source).value)
            # calculate timecodes
            src_in = ((Timecode.parse(mark[:in]) - start_tc).to_f / 25.0).to_f
            src_out = ((Timecode.parse(mark[:out]) - start_tc).to_f / 25.0).to_f
            # push mark
            marks << Narra::MarkSequence.new(clip: item, row: index, in: src_in, out: src_out)
          end
        end
        # push new sequence entry
        model.sequences << Narra::Sequence.new(name: options[:name], author: author, marks: marks)
      end
    end
  end
end