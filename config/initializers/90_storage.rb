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

require 'fog'
require 'fog/aws'
require 'carrierwave'

# Setup instance name
module Narra
  module Storage
    INSTANCE = 'narra-' + (ENV['NARRA_INSTANCE_NAME'] ||= 'testing') + '-storage'
    TYPE = (ENV['NARRA_STORAGE_TYPE'] ||= 'local').downcase
  end
end

# Recreating temp
FileUtils.rm_rf(Narra::Tools::Settings.storage_temp)
FileUtils.mkdir_p(Narra::Tools::Settings.storage_temp)

# Storage initialization
# Set up storage type
case Narra::Storage::TYPE
  when :local
    CarrierWave.configure do |config|
      config.storage = 'file'
      config.root = Narra::Tools::Settings.storage_local_path
      config.asset_host = Narra::Tools::Settings.storage_local_endpoint
      config.permissions = 0666
      config.directory_permissions = 0777
      config.cache_dir = Narra::Tools::Settings.storage_temp
    end
  when :aws
    CarrierWave.configure do |config|
      config.storage = 'fog'
      config.fog_credentials = {
          provider: 'AWS',
          aws_access_key_id: ENV['AWS_ACCESS_KEY'],
          aws_secret_access_key: ENV['AWS_SECRET'],
          region: ENV['AWS_REGION'],
      }
      config.fog_directory = ENV['AWS_BUCKET']
      config.cache_dir = Narra::Tools::Settings.storage_temp
    end
  when :google
    CarrierWave.configure do |config|
      config.fog_provider = 'fog-google'
      config.fog_credentials = {
          provider: 'Google',
          google_storage_access_key_id: ENV['GOOGLE_CLIENT_ID'],
          google_storage_secret_access_key: ENV['GOOGLE_CLIENT_SECRET']
      }
      config.fog_directory = ENV['GOOGLE_BUCKET']
      config.cache_dir = Narra::Tools::Settings.storage_temp
    end
end