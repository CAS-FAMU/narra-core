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
    class UsersV1 < Grape::API

      version 'v1', :using => :path
      format :json

      helpers API::Helpers::User

      resource :users do

        desc "Return users."
        get do
          authenticate!
          present API::Wrappers::User.users(User.all), with: API::Entities::User
        end

        desc "Return logged user in the current session."
        get 'me' do
          authenticate!
          present API::Wrappers::User.user(current_user), with: API::Entities::User
        end

        desc "Signout logged user in the current session."
        get 'me/signout' do
          authenticate!
          signout && { status: API::Enums::Status::OK }
        end

        desc "Return a specific user."
        get ':id' do
          authenticate!
          # get user
          user = User.find(params[:id])
          # present or not found
          if (user.nil?)
            present API::Wrappers::Error.error_not_found, with: API::Entities::Error
          else
            present API::Wrappers::User.user(user), with: API::Entities::User
          end
        end
      end
    end
  end
end