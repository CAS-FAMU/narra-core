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
    module Modules
      class ItemsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :items do

          desc "Return all items."
          get do
            return_many(Item, Narra::API::Entities::Item, [:admin, :author])
          end

          desc "Create new item."
          post 'new' do
            required_attributes! [:name, :url, :collection]
            new_one(Item, Narra::API::Entities::Item, :name, {name: params[:name], url: params[:url], owner: current_user}, [:admin, :author]) do |item|
              # check for the collection if any
              collection = Collection.find_by(name: params[:collection]) unless params[:collection].nil?
              # authorize the owner
              if !collection.nil?
                authorize!([:author], collection)
                # add into collection if authorized
                item.collections << collection unless params[:collection].nil?
              end
              # create source metadata from essential fields
              item.meta << Meta.new(name: 'name', content: params[:name], generator: :source)
              item.meta << Meta.new(name: 'url', content: params[:url], generator: :source)
              item.meta << Meta.new(name: 'collection', content: params[:collection], generator: :source)
              item.meta << Meta.new(name: 'owner', content: current_user.name, generator: :source)
              # parse metadata if exists
              if !params[:metadata].nil? && !params[:metadata].empty?
                # iterate through hash
                params[:metadata].each do |key, value|
                  # store new source metadata
                  item.meta << Meta.new(name: key, content: value, generator: :source)
                end
              end
            end
          end

          desc "Return a specific item."
          get ':name' do
            return_one(Item, Narra::API::Entities::Item, :name, [:admin, :author])
          end

          desc "Delete a specific item."
          get ':name/delete' do
            delete_one(Item, :name, [:admin, :author])
          end

          desc "Run generator over specified item"
          post ':name/generate' do
            required_attributes! [:generators]
            return_one_custom(Item, :name, [:admin, :author]) do |item|
              # Process item
              events = Narra::Core.generate(item, params[:generators])
              # Present event
              present_ok(:events, present(events, with: Narra::API::Entities::Event))
            end
          end

          desc "Return item's events."
          get ':name/events' do
            return_one_custom(Item, :name, [:admin, :author]) do |item|
              present_ok(:events, present(item.events, with: Narra::API::Entities::Event))
            end
          end
        end
      end
    end
  end
end