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
  class MetaItem < Meta
    # Fields
    field :generator, type: Symbol

    # Relations
    belongs_to :item, autosave: true, inverse_of: :meta, class_name: 'Narra::Item'
    has_many :marks, autosave: true, dependent: :destroy, inverse_of: :meta, class_name: 'Narra::MarkMeta'

    # Validations
    validates_uniqueness_of :name, :scope => [:generator, :item_id]
    validates_presence_of :generator

    # Scopes
    scope :generators, ->(generators, source = true) { any_in(generator: source ? (generators | [:source]) : generators) }
  end
end