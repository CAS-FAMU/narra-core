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
      class CollectionsV1 < Narra::API::Modules::Generic

        version 'v1', :using => :path
        format :json

        helpers Narra::API::Helpers::User
        helpers Narra::API::Helpers::Error
        helpers Narra::API::Helpers::Present
        helpers Narra::API::Helpers::Generic
        helpers Narra::API::Helpers::Attributes

        resource :collections do

          desc "Return all collections."
          get do
            return_many(Collection, Narra::API::Entities::Collection, [:admin, :author])
          end

          desc "Create new collection."
          post 'new' do
            required_attributes! [:name, :title]
            new_one(Collection, Narra::API::Entities::Collection, :name, {name: params[:name], title: params[:title], owner: current_user}, [:admin, :author]) do |collection|
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
            return_one(Collection, Narra::API::Entities::Collection, :name, [:admin, :author])
          end

          desc "Update a specific collection."
          post ':name/update' do
            required_attributes! [:title]
            update_one(Collection, Narra::API::Entities::Collection, :name, [:admin, :author]) do |collection|
              collection.update_attributes(title: params[:title])
            end
          end

          desc "Delete a specific collection."
          get ':name/delete' do
            delete_one(Collection, :name, [:admin, :author])
          end

          desc "Return a specific collection's items."
          get ':name/items' do
            auth! [:admin, :author]
            # get user
            collection = Collection.find_by(name: params[:name])
            # present or not found
            if (collection.nil?)
              error_not_found!
            else
              present_ok(:items, present(collection.items, with: Narra::API::Entities::Item))
            end
          end
        end
      end
    end
  end
end