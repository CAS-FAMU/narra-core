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

require 'carrierwave'

# Setup instance name
module Narra
  module Storage
    INSTANCE = 'narra-' + (ENV['NARRA_INSTANCE_NAME'] ||= 'testing') + '-storage'
    SELECTED = Narra::Storages::Local
  end
end

# Recreating temp
FileUtils.rm_rf(Narra::Tools::Settings.storage_temp)
FileUtils.mkdir_p(Narra::Tools::Settings.storage_temp)

# Search for a storage type
Narra::SPI::Storage.descendants.each do |storage|
  if storage.identifier != :local && storage.valid?
    Narra::Storage::SELECTED = storage
  end
end

# Storage initialization
Narra::Storage::SELECTED.new