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

require 'fog/aws'

module Narra
  module Storages
    class DigitalOcean < Narra::SPI::Storage

      # Default values
      @identifier = :dos
      @title = 'DigitalOcean Spaces'
      @description = 'Central storage with cloud accessor'
      @requirements = ['DOS_ACCESS_KEY', 'DOS_SECRET', 'DOS_REGION', 'DOS_SPACE']

      def initialization(config)
        config.storage = :fog
        config.fog_provider = 'fog/aws'
        config.fog_credentials = {
            provider: 'AWS',
            aws_access_key_id: ENV['DOS_ACCESS_KEY'],
            aws_secret_access_key: ENV['DOS_SECRET'],
            region: ENV['DOS_REGION'],
            endpoint: 'https://' + ENV['DOS_REGION'] + '.digitaloceanspaces.com'
        }
        config.fog_directory = ENV['DOS_SPACE']
        config.cache_dir = Narra::Tools::Settings.storage_temp
      end
    end
  end
end