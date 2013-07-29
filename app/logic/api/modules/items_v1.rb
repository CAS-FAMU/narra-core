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

module API
  module Modules
    class ItemsV1 < Grape::API

      version 'v1', :using => :path
      format :json

      helpers API::Helpers::User
      helpers API::Helpers::Error
      helpers API::Helpers::Present

      resource :items do

        desc "Return all items."
        get do
          authenticate!
          authorize!([:admin, :author])
          present_ok(:items, present(Item.all, with: API::Entities::Item))
        end

        desc "Create new item."
        params do
          requires :name, type: String, desc: "Unique name of a new item."
          requires :url, type: String, desc: "URL of the item's stream."
          requires :collection, type: String, desc: "Unique name of the collection."
          optional :metadata, type: Hash, desc: "Metadata fields."
        end
        post 'new' do
          authenticate!
          authorize!([:admin, :author])
          # get project
          collection = Collection.find_by(name: params[:collection]) unless params[:collection].nil?
          # authorize the owner
          if !collection.nil?
            authorize!([:author], collection)
          end
          # get collection
          item = Item.find_by(name: params[:name])
          # present or not found
          if item.nil?
            # create new collection
            item = Item.create(name: params[:name], url: params[:url], owner: current_user)
            # add into project
            item.collections << collection unless params[:collection].nil?
            # parse metadata if exists
            if !params[:metadata].nil? && !params[:metadata].empty?
              # iterate through hash
              params[:metadata].each do |key, value|
                # store new source metadata
                item.meta << Meta.new(name: key, content: value, provider: :source)
              end
            end
            # persist
            item.save
            # present
            present_ok(:item, present(item, with: API::Entities::Item, type: :detail))
          else
            error_already_exists
          end
        end

        desc "Return a specific item."
        get ':name' do
          authenticate!
          authorize!([:admin, :author])
          # get project
          item = Item.find_by(name: params[:name])
          # present or not found
          if (item.nil?)
            error_not_found
          else
            # authorize the owner
            authorize!([:author], item)
            # present
            present_ok(:item, present(item, with: API::Entities::Item, type: :detail))
          end
        end

        desc "Delete a specific item."
        get ':name/delete' do
          authenticate!
          authorize!([:admin, :author])
          # get collection
          item = Item.find_by(name: params[:name])
          # present or not found
          if (item.nil?)
            error_not_found
          else
            # authorize the owner
            authorize!([:author], item)
            # destroy
            item.destroy
            # present
            present_ok
          end
        end
      end
    end
  end
end