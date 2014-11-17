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
            required_attributes! [:url, :collection]
            new_one_custom(Item, Narra::API::Entities::Item, [:admin, :author]) do
              # trying to get collection
              collection = Collection.find(params[:collection])
              # input metadata container
              metadata = []
              # check for metadata
              if !params[:metadata].nil? && !params[:metadata].empty?
                # iterate through hash
                params[:metadata].each do |key, value|
                  # store new source metadata
                  metadata << {name: key, content: value}
                end
              end
              # add new item
              Narra::Core.add_item(params[:url], current_user, collection, metadata)
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