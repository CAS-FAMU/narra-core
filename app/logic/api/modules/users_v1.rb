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
      helpers API::Helpers::Error
      helpers API::Helpers::Present
      helpers API::Helpers::Generic

      resource :users do

        desc "Return users."
        get do
          return_many(User, API::Entities::User, [:admin])
        end

        desc "Return logged user in the current session."
        get 'me' do
          authenticate!
          present_ok(:user, present(current_user, with: API::Entities::User))
        end

        desc "Signout logged user in the current session."
        get 'me/signout' do
          authenticate!
          # signout
          signout
          # return
          present_ok
        end

        desc "Return roles."
        get 'roles' do
          authenticate!
          authorize!([:admin])
          present_ok(:roles, present(User.all_roles))
        end

        desc "Return a specific user."
        get ':id' do
          return_one(User, API::Entities::User, :id, [:admin])
        end

        desc "Delete a specific user."
        get ':id/delete' do
          delete_one(User, :id, [:admin])
        end

        desc "Update a user."
        params do
          requires :roles, :type => Array, :desc => "User roles."
        end
        post ':id/update' do
          update_one(User, API::Entities::User, :id, [:admin]) do |user|
            user.roles = params[:roles].collect {|role| role.to_sym}
          end
        end
      end
    end
  end
end