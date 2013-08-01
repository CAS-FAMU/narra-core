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
        expose :name, :url
        expose :owner do |model, options|
          { id: model.owner._id, name: model.owner.name}
        end
        expose :collections, using: Narra::API::Entities::Collection, :if => {:type => :detail}
        expose :meta, as: :metadata, :if => {:type => :detail} do |item, options|
          # get scoped metadata for item
          meta = options[:project].nil? ? item.meta : ::Meta.where(item: item).generators(options[:project].generators)
          # format them
          meta.collect { |m| { name: m.name, content: m.content, generator: m.generator} }
        end
      end
    end
  end
end