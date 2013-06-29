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
  module Modules
    class ItemsV1 < Grape::API

      version 'v1', :using => :path
      format :json

      helpers API::Helpers::User

      resource :items do

        desc "Return all items."
        get do
          authenticate!
          present API::Wrappers::Item.items(Item.all), with: API::Entities::Item
        end

        desc "Return a specific item."
        get ':_id' do
          authenticate!
          # get user
          item = Item.find_by(_id: params[:_id])
          # present or not found
          if (item.nil?)
            present API::Wrappers::Error.error_not_found, with: API::Entities::Error
          else
            present API::Wrappers::Item.item(item), with: API::Entities::Item
          end
        end

        desc "Delete a specific item."
        get ':_id/delete' do
          authenticate!
          # get user
          item = Item.find_by(_id: params[:_id])
          # present or not found
          if (item.nil?)
            present API::Wrappers::Error.error_not_found, with: API::Entities::Error
          else
            item.destroy && { status: API::Enums::Status::OK }
          end
        end

      end
    end
  end
end