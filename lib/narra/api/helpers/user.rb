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
    module Helpers
      module User

        def authenticate!
          error_not_authenticated! unless current_user
        end

        def authorize!(roles, object = nil)
          if object.nil?
            error_not_authorized! unless current_user.is?(roles)
          else
            if object.has_attribute?('owner_id') && !current_user.is?([:admin]) && current_user.is?(roles)
              error_not_authorized! unless object.owner._id == current_user._id
            end
          end
        end

        def current_user
          # check for token presence
          return nil if params[:token].nil? && env['rack.session'][:token].nil?

          begin
            # set token to session
            env['rack.session'][:token] = params[:token] unless params[:token].nil?

            # get uid
            uid = Base64::urlsafe_decode64(env['rack.session'][:token])

            # get identity for token
            identity = Identity.where(uid: uid).first

            # signout in case non existing identity
            raise && signout if identity.nil?

            # return user
            @current_user ||= identity.user
          rescue
            return nil
          end
        end

        def signout
          # clean current user
          @current_user = nil
          # delete session token
          env['rack.session'][:token] = nil
        end
      end
    end
  end
end
