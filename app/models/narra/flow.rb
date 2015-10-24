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
  class Flow
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Extensions::Thumbnail

    # Fields
    field :name, type: String

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :flows, class_name: 'Narra::User'

    # Projects Relations
    belongs_to :project, autosave: true, inverse_of: :flows, class_name: 'Narra::Project'

    # Marks
    has_many :marks, autosave: true, dependent: :destroy, inverse_of: :flow, class_name: 'Narra::MarkFlow'

    # Validations
    validates_uniqueness_of :project, scope: [:name]
    validates_presence_of :name, :author, :project

    # Callbacks
    after_destroy :broadcast_events_destroyed
    after_create :broadcast_events_created

    # Return type of the flow
    def type
      _type.split('::').last.downcase.to_sym
    end

    def prepared?
      # This has to be overridden in descendants
      return false
    end

    def models
      project.items.any_in(name: marks.collect { |mark| mark.clip })
    end

    protected

    def broadcast_events_destroyed
      broadcast("narra_#{type}_destroyed".to_sym, {project: self.project.name, flow: self._id.to_s})
    end

    def broadcast_events_created
      # broadcast all events
      broadcast("narra_#{type}_created".to_sym, {project: self.project.name, flow: self._id.to_s})
    end
  end
end