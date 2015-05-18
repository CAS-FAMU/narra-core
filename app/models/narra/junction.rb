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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

module Narra
  class Junction
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :weight, type: Float
    field :synthesizer, type: Symbol
    field :sources, type: Array, default: []
    field :direction, type: Hash, default: {none: true}

    # Project relation
    belongs_to :project, autosave: true, inverse_of: :junctions, class_name: 'Narra::Project'

    # Item Relations
    has_and_belongs_to_many :items, autosave: true, inverse_of: :junctions, class_name: 'Narra::Item'

    # Validations
    validates_uniqueness_of :project, scope: [:synthesizer, :direction, :item_ids]
    validates_presence_of :weight, :synthesizer, :project, :items

    # Scopes
    scope :project, ->(project) { where(project: project) }
    scope :synthesizer, ->(synthesizer) { where(synthesizer: synthesizer) }
  end
end