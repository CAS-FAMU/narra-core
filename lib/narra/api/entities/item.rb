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
  module API
    module Entities
      class Item < Grape::Entity

        expose :_id, as: 'id'
        expose :name
        expose :url
        expose(:owner) { |model, options| {id: model.owner._id, name: model.owner.name} }
        expose :collections, format_with: :collections, :if => {:type => :detail}
        expose :meta, as: 'metadata', format_with: :metadata, :if => {:type => :detail}

        format_with :collections do |collections|
          collections.collect { |collection| {id: collection._id, name: collection.name, title: collection.title, owner: {id: collection.owner._id, name: collection.owner.name}} }
        end

        format_with :metadata do |metadata|
          metadata.collect { |meta| {name: meta.name, content: meta.content, provider: meta.provider} }
        end
      end
    end
  end
end