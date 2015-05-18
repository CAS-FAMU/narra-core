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
  module Core
    module Sequences
      include Narra::Extensions::Sequence

      # Add sequence into the NARRA
      def Core.add_sequence(project, author, params = {})
        # input check
        return if params[:sequence_name].nil? || params[:sequence_type].nil? || params[:sequence_content].nil?
        # get type of the sequence
        case params[:type]
          when :edl
            # input check
            return if params[:edl_fps].nil?
            # process edl
            process(type: :sequence, project: project.name, identifier: :edl, params: params.merge({author: author._id.to_s}))
        end
      end
    end
  end
end