#
# Copyright (C) 2014 CAS / FAMU
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

require 'fog'

# Setup Default Storage
module Narra
  module Storage

    def self.items
      # get items property
      @items_property ||= ENV['NARRA_INSTANCE_NAME'].downcase + '-' + Narra::Tools::Settings.storage_s3_items
      # get items storage
      @items ||= storage.directories.get(@items_property).nil? ? storage.directories.create(key: @items_property, public: true) : storage.directories.get(@items_property)
    end

    private

    def self.storage
      if @storage.nil?
        # resolve type of the storage
        @type ||= ENV['NARRA_AWS_ACCESS_KEY'].nil? ? :local : :s3

        # create storage
        case @type
          when :local
            @storage = Fog::Storage.new({
                                            provider: 'Local',
                                            local_root: Narra::Tools::Settings.storage_local_path,
                                            endpoint: Narra::Tools::Settings.storage_local_endpoint
                                        })
          when :s3
            @storage = Fog::Storage.new({
                                            provider: 'AWS',
                                            aws_access_key_id: ENV['NARRA_AWS_ACCESS_KEY'],
                                            aws_secret_access_key: ENV['NARRA_AWS_SECRET'],
                                            region: ENV['NARRA_AWS_REGION']
                                        })
        end
      end

      # return storage
      @storage
    end
  end
end