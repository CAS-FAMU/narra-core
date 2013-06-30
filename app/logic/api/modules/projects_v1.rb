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

      resource :projects do

        desc "Return all projects."
        get do
          authenticate!
          present API::Wrappers::Project.projects(Project.all), with: API::Entities::Project
        end



        desc "Create new project."
        params do
          requires :name, type: String, desc: "Name of new project."
          requires :title, type: String, desc: "Title of new project."
        end

        get 'new' do
          authenticate!
          # get user
          project = Project.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            tmp = Project.new(name: params[:name], title: params[:title], owner_id: current_user._id)
            tmp.save
            present API::Wrappers::Project.project(tmp), with: API::Entities::Project
          else
            present API::Wrappers::Error.error_already_exists, with: API::Entities::Error
          end
        end


        desc "Return a specific project."
        get ':name' do
          authenticate!
          # get user
          project = Project.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            present API::Wrappers::Error.error_not_found, with: API::Entities::Error
          else
            present API::Wrappers::Project.project(project), with: API::Entities::Project
          end
        end

        desc "Delete a specific project."
        get ':name/delete' do
          authenticate!
          # get user
          project = User.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            present API::Wrappers::Error.error_not_found, with: API::Entities::Error
          else
            project.destroy && { status: API::Enums::Status::OK }
          end
        end

      end
    end
  end
end