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

# Recreating temp
FileUtils.rm_rf(Narra::Tools::Settings.storage_temp)
FileUtils.mkdir_p(Narra::Tools::Settings.storage_temp)

# Setup Default Storage
module Narra
  module Storage
    # Items folder
    ITEMS ||= Fog::Storage.new({ local_root: Narra::Tools::Settings.storage_local_path + '/items',
                                   endpoint: Narra::Tools::Settings.storage_local_endpoint + '/items',
                                   provider: 'Local' })
  end
end

