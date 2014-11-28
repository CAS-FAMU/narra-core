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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

require 'sidekiq'

if Rails.env.development? || Rails.env.test?
  ENV['NARRA_REDIS_HOST'] = 'localhost'
  ENV['NARRA_REDIS_PORT'] = '6379'
end

Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://' + ENV['NARRA_REDIS_HOST'] + ':' + ENV['NARRA_REDIS_PORT'] + '/0', :namespace => 'narra' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://' + ENV['NARRA_REDIS_HOST'] + ':' + ENV['NARRA_REDIS_PORT'] + '/0', :namespace => 'narra' }
end