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
  class Item
    include Mongoid::Document
    include Mongoid::Timestamps
    include Narra::Extensions::Thumbnail
    include Narra::Extensions::MetaItem

    # Fields
    field :name, type: String
    field :url, type: String
    field :files, type: Array, default: []

    # Library Relations
    belongs_to :library, autosave: true, inverse_of: :items, class_name: 'Narra::Library'

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :item, class_name: 'Narra::MetaItem'

    # Junction Relations
    has_many :in, autosave: true, dependent: :destroy, inverse_of: :out, class_name: 'Narra::Junction'
    has_many :out, autosave: true, dependent: :destroy, inverse_of: :in, class_name: 'Narra::Junction'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :item, class_name: 'Narra::Event'

    # Validations
    validates_uniqueness_of :name, scope: :library_id
    validates_presence_of :name, :url

    # Scopes
    scope :user, ->(user) { any_in(library_id: Library.user(user).pluck(:id)) }

    # Hooks
    # Destroy item's directory after destroy
    after_destroy do |item|
      # destroy item's storage content
      item.files.each do |file|
        Narra::Storage.items.files.get(item._id.to_s + '/' + file).destroy
      end
    end

    # Helper methods
    # Return item's storage
    def get_file(name)
      Narra::Storage.items.files.get(self._id.to_s + '/' + name)
    end

    def create_file(name, body = nil)
      # create a new file
      file = Narra::Storage.items.files.create(key: self._id.to_s + '/' + name, body: body, public: true)
      # cache it
      files << name
      # return file
      return file
    end

    # Return as an array
    def items
      [self]
    end

    def item
      self
    end

    def type
      _type.split('::').last.downcase.to_sym
    end

    def prepared?
      # This has to be overridden in descendants
      return false
    end

    def generate
      Narra::Item.generate([self])
    end

    # Static methods
    # Check items for generated metadata
    def self.generate(input_items = nil)
      # resolve items
      items = input_items.nil? ? Narra::Item.all : input_items

      # run generator process for those where exact generator wasn't executed
      items.each do |item|
        item.library.generators.each do |generator|
          Narra::Core.generate(item, [generator]) if Narra::MetaItem.where(item: item).generators([generator], false).empty?
        end
      end
    end
  end
end