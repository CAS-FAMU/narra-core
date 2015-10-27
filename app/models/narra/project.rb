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
    include Wisper::Publisher
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::Meta
    include Narra::Extensions::Public

    # Fields
    field :name, type: String
    field :title, type: String
    field :description, type: String
    field :synthesizers, type: Array, default: []
    field :visualizations, type: Array, default: []

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::MetaProject'

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :projects, class_name: 'Narra::User'
    has_and_belongs_to_many :contributors, autosave: true, inverse_of: :projects_contributions, class_name: 'Narra::User'

    # Library Relations
    has_and_belongs_to_many :libraries, autosave: true, inverse_of: :projects, class_name: 'Narra::Library'

    # Junction Relations
    has_many :junctions, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Junction'
    has_many :flows, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Flow'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :project, class_name: 'Narra::Event'

    # Scopes
    scope :user, ->(user) { any_of({contributor_ids: user._id}, {author_id: user._id}) }

    # Validations
    validates_uniqueness_of :name
    validates_presence_of :name, :title, :author_id

    # Hooks
    after_update :broadcast_events

    # Return all project items
    def items
      Narra::Item.any_in(library_id: self.library_ids)
    end

    # Return all author's sequences
    def sequences
      flows.where(_type: 'Narra::Sequence')
    end

    # Return all users paths
    def paths
      flows.where(_type: 'Narra::Path')
    end

    # Return as an array
    def models
      items
    end

    # Return this project for Meta extension
    def model
      self
    end

    # Static methods
    # Synthesize
    def self.synthesize(project, synthesizer, options = {})
      # Input check
      return if project.nil? || synthesizer.nil?

      # Submit synthesize process only if the project has the synthesizer enabled
      if project.synthesizers.collect { |synthesizer| synthesizer[:identifier].to_s }.include?(synthesizer.to_s)
        Narra::Core.synthesize(project, [synthesizer], options)
      end
    end

    protected

    def broadcast_events
      broadcast(:narra_project_synthesizers_updated, {project: self.name, changes: self.changed_attributes['synthesizers']}) if self.synthesizers_changed?
    end
  end
end