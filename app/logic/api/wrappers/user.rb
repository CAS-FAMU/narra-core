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
  module Wrappers
    class User

      # Attributes
      attr_accessor :status
      attr_accessor :user
      attr_accessor :users

      def initialize(status, user = nil, users = nil)
        @status = status
        @user = user
        @users = users
      end

      def self.user(user)
        User.new(API::Enums::Status::OK, user, nil)
      end

      def self.users(users)
        User.new(API::Enums::Status::OK, nil, users)
      end
    end
  end
end