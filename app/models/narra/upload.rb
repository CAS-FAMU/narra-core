#
# Copyright (C) 2018 CAS / FAMU
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

require 'carrierwave/mongoid'

module Narra
  class Upload
    include Mongoid::Document
    include Mongoid::Timestamps

    field :filename, type: String

    # define direct uploader
    mount_uploader :file, Narra::DirectUploader

    # user relations
    belongs_to :user, autosave: true, inverse_of: :uploads, class_name: 'Narra::User'
  end
end