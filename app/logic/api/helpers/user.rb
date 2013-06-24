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
  module Helpers
    module User
      def authenticate!
        error!('Unauthenticated. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        # check for token presence
        return nil if cookies[:_narra_core_token].nil?

        # get identity for token
        identity = Identity.where(uid: Base64.urlsafe_decode64(cookies[:_narra_core_token])).first

        # signout in case non existing identity
        return nil && signout if identity.nil?

        # get user from token
        @current_user ||= identity.user
      end

      def signout
        # clean current user
        @current_user = nil
        # delete token
        cookies.delete :_narra_core_token, :path => '/'
      end
    end
  end
end
