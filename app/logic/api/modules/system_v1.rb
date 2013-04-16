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
# Authors: Michal Mocnak <michal@marigan.net>
#

module API
  module Modules
    class SystemV1 < Grape::API

      version 'v1', :using => :path
      format :json

      resource :system do

        desc "Return system version."
        get '/version' do
          {version: Tools::Version::VERSION, revision: Tools::Version::REVISION}
        end

        desc "Return settings."
        get '/settings' do
          Tools::Settings.all
        end

        desc "Return a specific setting."
        get '/settings/:name' do
          if params[:name] == "defaults"
            Tools::Settings.defaults
          else
            {value: Tools::Settings.get(params[:name])}
          end
        end

        desc "Update a specific setting."
        params do
          requires :value, :type => String, :desc => "Setting value."
        end
        put ':name' do
          Tools::Settings.set(params[:name], params[:value])
        end
      end
    end
  end
end