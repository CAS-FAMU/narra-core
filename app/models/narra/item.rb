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
    include Narra::Extensions::Meta

    # Fields
    field :name, type: String
    field :url, type: String

    # Library Relations
    belongs_to :library, autosave: true, inverse_of: :items, class_name: 'Narra::Library'

    # Sequence Relations
    belongs_to :sequence, autosave: true, inverse_of: :master, class_name: 'Narra::Sequence'

    # Meta Relations
    has_many :meta, autosave: true, dependent: :destroy, inverse_of: :item, class_name: 'Narra::MetaItem'

    # Junction Relations
    has_and_belongs_to_many :junctions, autosave: true, dependent: :destroy, inverse_of: :items, class_name: 'Narra::Junction'

    # Event Relations
    has_many :events, autosave: true, dependent: :destroy, inverse_of: :item, class_name: 'Narra::Event'

    # Thumbnail Relations
    has_many :thumbnails, autosave: true, dependent: :destroy, inverse_of: :item, class_name: 'Narra::ThumbnailItem'

    # Validations
    validates_uniqueness_of :name, scope: :library_id
    validates_presence_of :name, :url

    # Scopes
    scope :user, ->(user) { any_in(library_id: Library.user(user).pluck(:id)) }

    # Return as an array
    def models
      [self]
    end

    def model
      self
    end

    def type
      _type.split('::').last.downcase.to_sym
    end

    # Item is hidden for any process when it is assigned as master of the sequence
    def master?
      !sequence.nil?
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
          Narra::Core.generate(item, [generator[:identifier]]) if Narra::MetaItem.where(item: item).generators([generator[:identifier]], false).empty?
        end
      end
    end
  end
end