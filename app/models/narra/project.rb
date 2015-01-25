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
  class Project
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::MetaProject

    # Fields
    field :name, type: String
    field :title, type: String
    field :description, type: String
    field :synthesizers, type: Array, default: []

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::MetaProject'

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :projects, class_name: 'Narra::User'
    has_and_belongs_to_many :contributors, autosave: true, inverse_of: :projects_contributions, class_name: 'Narra::User'

    # Collection Relations
    has_and_belongs_to_many :libraries, autosave: true, inverse_of: :projects, class_name: 'Narra::Library'

    # Junction Relations
    has_many :junctions, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Junction'
    has_many :sequences, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Sequence'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Event'

    # Scopes
    scope :user, ->(user) { any_of({contributor_ids:user._id}, {author_id: user._id}) }

    # Validations
    validates_uniqueness_of :name
    validates_presence_of :name, :title, :author_id

    # Hooks
    # Create default public mark
    after_create do |project|
      project.add_meta(name: :public, value: false)
    end

    # Return all project items
    def items
      Narra::Item.any_in(library_id: self.library_ids)
    end

    # Return this project for MetaProject extension
    def project
      self
    end
  end
end