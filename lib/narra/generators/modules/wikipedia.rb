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

require 'wikipedia'

module Narra
  module Generators
    module Modules
      # Wikipedia Generator module
      class Wikipedia < Narra::Generators::Modules::Generic

        # Set title and description fields
        @identifier = :wikipedia
        @title = 'Wikipedia'
        @description = 'Wikipedia Metadata Generator based on opensearch algorithm via item name'

        def generate
          # prepare wikipedia client
          client = ::Wikipedia.client

          # get item's source meta name field
          data = @item.meta.select { |meta| meta.provider == 'source' && meta.name == 'name' }

          # perform opensearch on wiki
          results = JSON.parse(client.request(action: 'opensearch', search: data.first.content)) unless data.empty?

          # process results if not empy
          add_meta(name: 'opensearch', content: results[1]) unless results[1].empty?
        end
      end
    end
  end
end