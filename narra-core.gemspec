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

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "narra/core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "narra-core"
  spec.version     = Narra::Core::VERSION
  spec.authors     = ["Michal Mocnak", "Krystof Pesek"]
  spec.email       = ["info@narra.eu"]
  spec.homepage    = "http://www.narra.eu"
  spec.summary     = "NARRA Core functionality "
  spec.description = "NARRA Core functionality "
  spec.license     = "GPL-3.0"

  spec.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails", "~> 4.1.8"
  spec.add_dependency "mongoid"
  spec.add_dependency "aasm"
  spec.add_dependency "sidekiq"
  spec.add_dependency "fog"
  spec.add_dependency "wisper"
  spec.add_dependency "streamio-ffmpeg"
  spec.add_dependency "sinatra"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "mongoid-rspec"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "codeclimate-test-reporter"
end