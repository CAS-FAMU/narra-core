#
# Copyright (C) 2017 CAS / FAMU
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
  class Scenario
    include Mongoid::Document
    include Mongoid::Timestamps
    include Wisper::Publisher
    include Narra::Extensions::Shared

    # Fields
    field :name, type: String
    field :description, type: String

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :scenario, class_name: 'Narra::MetaScenario'

    # User Relations
    belongs_to :author, autosave: true, inverse_of: :scenario, class_name: 'Narra::User'

    # Validations
    validates_presence_of :name

    # Hooks
    after_update :broadcast_events

    def type
      _type.split('::').last.downcase.to_sym
    end

    def model
      self
    end
  end
end