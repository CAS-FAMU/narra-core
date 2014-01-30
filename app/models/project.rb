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

class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :title, type: String
  field :generators, type: Array, default: []
  field :synthesizers, type: Array, default: []

  # User Relations
  belongs_to :owner, class_name: 'User', autosave: true, inverse_of: :projects
  has_and_belongs_to_many :authors, class_name: 'User', autosave: true, inverse_of: :contributions

  # Collection Relations
  has_and_belongs_to_many :collections, class_name: 'Collection', autosave: true, inverse_of: :projects

  # Junction Relations
  has_many :junctions, class_name: 'Junction', autosave: true, dependent: :destroy, inverse_of: :project
  has_many :sequences, class_name: 'Sequence', autosave: true, dependent: :destroy, inverse_of: :project

  # Event Relations
  has_many :events, class_name: 'Event', autosave: true, dependent: :destroy, inverse_of: :project

  # Validations
  validate :name, presence: true, uniqueness: true
  validate :title, presence: true

  # Return all project items
  def items
    Item.any_in(collection_ids: self.collection_ids)
  end
end