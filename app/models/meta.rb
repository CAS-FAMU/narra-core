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

class Meta
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name, type: String
  field :content, type: String
  field :generator, type: Symbol

  # Relations
  belongs_to :item, class_name: "Item", autosave: true, inverse_of: :meta

  # Validations
  validates :name, presence: true
  validates :content, presence: true
  validates :generator, presence: true
  validates_uniqueness_of :name, :scope => [:generator, :item_id]

  # Scopes
  scope :generators, ->(generators, source = true) {any_in(generator: source ? (generators | [:source]) : generators)}
end