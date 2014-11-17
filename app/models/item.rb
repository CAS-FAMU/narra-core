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

class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include Narra::Extensions::Thumbnail

  # Fields
  field :name, type: String
  field :url, type: String

  # User Relations
  belongs_to :owner, class_name: 'User', autosave: true, inverse_of: :items

  # Library Relations
  belongs_to :library, autosave: true, inverse_of: :items

  # Meta Relations
  has_many :meta, autosave: true, dependent: :destroy, inverse_of: :item

  # Junction Relations
  has_many :in, class_name: 'Junction', autosave: true, dependent: :destroy, inverse_of: :out
  has_many :out, class_name: 'Junction', autosave: true, dependent: :destroy, inverse_of: :in

  # Event Relations
  has_many :events, autosave: true, dependent: :destroy, inverse_of: :item

  # Validations
  validates_uniqueness_of :name, scope: :library_id
  validates_presence_of :name, :url, :owner_id

  # Hooks
  # Create item's directory after create
  after_create do |item|
    # create item's storage
    Narra::Storage::ITEMS.directories.create(key: item._id.to_s, public: true)
  end

  # Destroy item's directory after destroy
  after_destroy do |item|
    # destroy item's storage content
    item.storage.files.each do |file|
      file.destroy
    end
    # destroy item's storage
    item.storage.destroy
  end

  # Helper methods
  # Return item's storage
  def storage
    Narra::Storage::ITEMS.directories.get(self._id.to_s)
  end

  def generate
    Item.generate(self)
  end

  # Return as an array
  def items
    [self]
  end

  def prepared?
    # This has to be overridden in descendants
    return false
  end

  # Static methods
  # Check items for generated metadata
  def self.generate(input_item = nil)
    # resolve items
    items = input_item.nil? ? Item.all : [input_item]

    # run generator process for those where exact generator wasn't executed
    items.each do |item|
      Narra::Core.generators_identifiers.each do |generator|
        Narra::Core.generate(item, [generator]) if ::Meta.where(item: item).generators([generator], false).empty?
      end
    end
  end
end