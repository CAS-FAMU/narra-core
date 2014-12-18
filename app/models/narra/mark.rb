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
  class Mark
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :index, type: Integer
    field :in, type: Float
    field :out, type: Float

    # Relations
    belongs_to :meta, autosave: true, inverse_of: :marks, class_name: 'Narra::Meta'
    belongs_to :sequence, autosave: true, inverse_of: :playlist, class_name: 'Narra::Sequence'

    validates_presence_of :in
  end
end