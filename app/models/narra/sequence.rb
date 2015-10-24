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
  class Sequence < Flow
    include Narra::Extensions::Meta
    include Narra::Extensions::Public

    # Fields
    field :description, type: String
    field :fps, type: Float
    field :prepared, type: Boolean, default: false

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :sequence, class_name: 'Narra::MetaSequence'

    # User Relations
    has_and_belongs_to_many :contributors, autosave: true, inverse_of: :sequences_contributions, class_name: 'Narra::User'

    # Item Relations
    has_one :master, inverse_of: :sequence, class_name: 'Narra::Item'

    # Return this sequence for Meta extension
    def model
      self
    end

    def prepared?
      # This has to be overridden in descendants
      prepared
    end
  end
end