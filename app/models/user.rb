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

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :username, type: String
  field :name, type: String
  field :email, type: String
  field :roles, type: Array, default: []

  # Project Relations
  has_many :projects, class_name: "Project", autosave: true, dependent: :destroy, inverse_of: :owner
  has_and_belongs_to_many :contributions, class_name: "Project", autosave: true, inverse_of: :authors

  # Collection Relations
  has_many :collections, class_name: "Collection", autosave: true, inverse_of: :owner

  # Collection Items
  has_many :items, class_name: "Item", autosave: true, inverse_of: :owner

  # Identity Relations
  has_many :identities, dependent: :destroy

  # Validations
  validates_uniqueness_of :username

  # Check if the user has certain role
  def is?(roles_check = [])
    !(roles & roles_check).empty?
  end

  # Get all roles registered in the system
  def self.all_roles
    User.only(:roles).map(&:roles).reduce(:+).uniq
  end

  # Create a new user from the omniauth hash
  def self.create_from_hash!(hash)
    # create new user
    user = User.new(username: hash['info']['name'].downcase.tr(' ', '_'), name: hash['info']['name'], email: hash['info']['email'])

    # assign default roles
    user.roles = (User.empty?) ? [:admin] : [:author]

    # save
    return (user.save) ? user : nil
  end
end