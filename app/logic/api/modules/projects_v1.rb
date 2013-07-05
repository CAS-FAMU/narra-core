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
          present({ status: API::Enums::Status::OK, projects: present(Project.all, with: API::Entities::Project)})
        end

        desc "Create new project."
        params do
          requires :name, type: String, desc: "Name of new project."
          requires :title, type: String, desc: "Title of new project."
        end

        get 'new' do
          authenticate!
          # get project
          project = Project.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            present({ status: API::Enums::Status::OK, project: present(Project.create(name: params[:name], title: params[:title], owner_id: current_user._id),
                                                                       with: API::Entities::Project)})
          else
            error!({ status: API::Enums::Status::ERROR, message: API::Enums::Error::ALREADY_EXISTS[:message] },
                   API::Enums::Error::ALREADY_EXISTS[:status])
          end
        end

        desc "Return a specific project."
        get ':name' do
          authenticate!
          # get project
          project = Project.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            error!({ status: API::Enums::Status::ERROR, message: API::Enums::Error::NOT_FOUND[:message] },
                   API::Enums::Error::NOT_FOUND[:status])
          else
            present({ status: API::Enums::Status::OK, project: present(project, with: API::Entities::Project)})
          end
        end

        desc "Delete a specific project."
        get ':name/delete' do
          authenticate!
          # get user
          project = User.find_by(name: params[:name])
          # present or not found
          if (project.nil?)
            error!({ status: API::Enums::Status::ERROR, message: API::Enums::Error::NOT_FOUND[:message] },
                   API::Enums::Error::NOT_FOUND[:status])
          else
            project.destroy && { status: API::Enums::Status::OK }
          end
        end
      end
    end
  end
end