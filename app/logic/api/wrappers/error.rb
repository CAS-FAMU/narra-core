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
    class Error

      # Attributes
      attr_accessor :status
      attr_accessor :message

      def initialize(status, message)
        @status = status
        @message = message
      end

      def self.error_access_denied
        Error.new(API::Enums::Status::ERROR, "Access Denied")
      end

      def self.error_not_found
        Error.new(API::Enums::Status::ERROR, "Not Found")
      end


      def self.error_already_exists
        Error.new(API::Enums::Status::ERROR, "Object already exist")
      end
    end
  end
end