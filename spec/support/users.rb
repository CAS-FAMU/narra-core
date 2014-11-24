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

RSpec.configure do |config|
  config.before(:each) do
    # create users
    # testing hashes
    admin_hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"admin@narra.eu","info":{"name":"Admin","email":"admin@narra.eu"},"credentials":{},"extra":{}}')
    author_hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"author@narra.eu","info":{"name":"Author","email":"author@narra.eu"},"credentials":{},"extra":{}}')
    unroled_hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"guest@narra.eu","info":{"name":"Unroled","email":"unroled@narra.eu"},"credentials":{},"extra":{}}')
    # create user and its identity
    Narra::Identity.create_from_hash(admin_hash)
    Narra::Identity.create_from_hash(author_hash)
    Narra::Identity.create_from_hash(unroled_hash)
    # get admin token and user
    @admin_token = CGI::escape(Base64.urlsafe_encode64(admin_hash['uid']))
    @admin_user = Narra::User.find_by(name: 'Admin')
    # get author token and user
    @author_token = CGI::escape(Base64.urlsafe_encode64(author_hash['uid']))
    @author_user = Narra::User.find_by(name: 'Author')
    # get guest token and user
    @unroled_token = CGI::escape(Base64.urlsafe_encode64(unroled_hash['uid']))
    @unroled_user = Narra::User.find_by(name: 'Unroled')
    @unroled_user.roles = []
    @unroled_user.save
  end
end