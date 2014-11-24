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
  class Library
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail

    # Fields
    field :name, type: String
    field :title, type: String
    field :description, type: String

    # User Relations
    belongs_to :owner, autosave: true, inverse_of: :libraries, class_name: 'Narra::User'

    # Item Relations
    has_many :items, autosave: true, dependent: :destroy, inverse_of: :library, class_name: 'Narra::Item'

    # Project Relations
    has_and_belongs_to_many :projects, autosave: true, inverse_of: :libraries, class_name: 'Narra::Project'

    # Validations
    validates_uniqueness_of :name
    validates_presence_of :name, :title, :owner_id
  end
end