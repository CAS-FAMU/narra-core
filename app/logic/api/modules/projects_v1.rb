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
    class ProjectsV1 < Grape::API

      version 'v1', :using => :path
      format :json

      helpers API::Helpers::User
      helpers API::Helpers::Error
      helpers API::Helpers::Present
      helpers API::Helpers::Generic

      resource :projects do

        desc "Return all projects."
        get do
          return_many(Project, API::Entities::Project, [], false)
        end

        desc "Create new project."
        params do
          requires :name, type: String, desc: "Name of new project."
          requires :title, type: String, desc: "Title of new project."
        end
        post 'new' do
          new_one(Project, API::Entities::Project, :name, {name: params[:name], title: params[:title], owner: current_user}, [:admin, :author])
        end

        desc "Return a specific project."
        get ':name' do
          return_one(Project, API::Entities::Project, :name, [:admin, :author])
        end

        desc "Update a specific project."
        params do
          requires :name, type: String, desc: "Name of the project."
          requires :title, type: String, desc: "Title of the project to be saved."
        end
        post ':name/update' do
          update_one(Project, API::Entities::Project, :name, [:admin, :author]) do |project|
            project.update_attributes(title: params[:title])
          end
        end

        desc "Delete a specific project."
        get ':name/delete' do
          delete_one(Project, :name, [:admin, :author])
        end

        desc "Add or remove specific collections."
        params do
          requires :name, type: String, desc: "Name of the project."
          requires :collections, type: Array, desc: "Array of the collections names."
        end
        post ':name/:action' do
          update_one(Project, API::Entities::Project, :name, [:admin, :author]) do |project|
            params[:collections].each do |collection|
              if params[:action] == 'add'
                project.collections << Collection.find_by(name: collection)
              elsif params[:action] == 'remove'
                project.collections.delete(Collection.find_by(name: collection))
              end
            end
          end
        end
      end
    end
  end
end