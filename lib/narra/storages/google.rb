#
# Copyright (C) 2017 CAS / FAMU
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
# Authors: Michal Mocnak <michal@marigan.net>
#

require 'fog/google'

module Narra
  module Storages
    class Google < Narra::SPI::Storage

      # Default values
      @identifier = :google
      @title = 'Google Cloud Storage'
      @description = 'Central storage with cloud accessor'
      @requirements = ['GOOGLE_STORAGE_ID', 'GOOGLE_STORAGE_SECRET', 'GOOGLE_STORAGE_BUCKET']

      def initialization(config)
        config.storage = :fog
        config.fog_provider = 'fog/google'
        config.fog_credentials = {
            provider: 'Google',
            google_storage_access_key_id: ENV['GOOGLE_STORAGE_ID'],
            google_storage_secret_access_key: ENV['GOOGLE_STORAGE_SECRET']
        }
        config.fog_directory = ENV['GOOGLE_STORAGE_BUCKET']
        config.cache_dir = Narra::Tools::Settings.storage_temp
      end
    end
  end
end