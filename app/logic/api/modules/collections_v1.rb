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
    class CollectionsV1 < API::Modules::Generic

      version 'v1', :using => :path
      format :json

      helpers API::Helpers::User
      helpers API::Helpers::Error
      helpers API::Helpers::Present
      helpers API::Helpers::Generic

      resource :collections do

        desc "Return all collections."
        get do
          return_many(Collection, API::Entities::Collection, [:admin, :author])
        end

        desc "Create new collection."
        params do
          requires :name, type: String, desc: "Name of new collection."
          requires :title, type: String, desc: "Title of new collection."
          optional :project, type: String, desc: "Unique name of the project."
        end
        post 'new' do
          new_one(Collection, API::Entities::Collection, :name, {name: params[:name], title: params[:title], owner: current_user}, [:admin, :author]) do |collection|
            # check for the project if any
            project = Project.find_by(name: params[:project]) unless params[:project].nil?
            # authorize the owner
            if !project.nil?
              authorize!([:author], project)
              # update projects if authorized
              collection.projects << project
            end
          end
        end

        desc "Return a specific collection."
        get ':name' do
          return_one(Collection, API::Entities::Collection, :name, [:admin, :author])
        end

        desc "Return a specific collection's items."
        get ':name/items' do
          authenticate!
          authorize!([:admin, :author])
          # get user
          collection = Collection.find_by(name: params[:name])
          # present or not found
          if (collection.nil?)
            error_not_found
          else
            present_ok(:items, present(collection.items, with: API::Entities::Item))
          end
        end

        desc "Update a specific collection."
        params do
          requires :name, type: String, desc: "Name of the collection."
          requires :title, type: String, desc: "Title of the collection to be saved."
        end
        post ':name/update' do
          update_one(Collection, API::Entities::Collection, :name, [:admin, :author]) do |collection|
            collection.update_attributes(title: params[:title])
          end
        end

        desc "Delete a specific collection."
        get ':name/delete' do
          delete_one(Collection, :name, [:admin, :author])
        end

        desc "Run generator over specified collection"
        params do
          requires :generators, type: Array, desc: "List of generators to be applied."
        end
        post ':name/generate' do
          return_one_custom(Collection, nil, :name, [:admin, :author]) do |collection|
            # Multi event list
            events = []
            # Process items in collection
            collection.items.each do |item|
              # Process item
              events << Generators.process(item, params[:generators])
            end
            # Present event
            present_ok(:events, events)
          end
        end
      end
    end
  end
end