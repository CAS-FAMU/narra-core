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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

module Narra
  class Sequence
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Extensions::Meta
    include Narra::Extensions::Public

    # Fields
    field :name, type: String

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :sequence, class_name: 'Narra::MetaSequence'

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :sequences, class_name: 'Narra::User'

    # Relations
    belongs_to :project, autosave: true, inverse_of: :sequences, class_name: 'Narra::Project'
    has_many :marks, autosave: true, dependent: :destroy, inverse_of: :sequence, class_name: 'Narra::MarkSequence'

    # Validations
    validates_uniqueness_of :project, scope: [:name]
    validates_presence_of :name, :author, :project, :marks

    # Callbacks
    after_destroy :broadcast_events_destroyed
    after_create :broadcast_events_created

    # Return this sequence for Meta extension
    def model
      self
    end

    protected

    def broadcast_events_destroyed
      broadcast(:narra_sequence_destroyed, { project: self.project.name, sequence: self._id.to_s })
    end

    def broadcast_events_created
      # broadcast all events
      broadcast(:narra_sequence_created, { project: self.project.name, sequence: self._id.to_s })
    end
  end
end