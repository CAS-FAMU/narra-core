#
# Copyright (C) 2013 CAS / FAMU
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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

module Narra
  class Junction
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :weight, type: Float
    field :synthesizer, type: Symbol

    # Project relation
    belongs_to :project, autosave: true, inverse_of: :junctions, class_name: 'Narra::Project'

    # Item Relations
    belongs_to :in, autosave: true, inverse_of: :out, class_name: 'Narra::Item'
    belongs_to :out, autosave: true, inverse_of: :in, class_name: 'Narra::Item'

    # Scopes
    scope :project, ->(project) { where(project: project) }
  end
end