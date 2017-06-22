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

require 'rails_helper'

describe Narra::SPI::Storage do
  it 'can be instantiated' do
    expect(Narra::SPI::Storage.new).to be_an_instance_of(Narra::SPI::Storage)
  end

  it 'should have accessible fields' do
    expect(Narra::SPI::Storage.identifier).to match(:generic)
    expect(Narra::SPI::Storage.title).to match('Generic')
    expect(Narra::SPI::Storage.description).to match('Generic Storage')
  end

  it 'can be checked for validity' do
    # validation
    expect(Narra::Storages::Testing.valid?).to be false
    # set test env variable
    ENV['TEST_REQUIREMENT_01'] = 'test'
    # validation
    expect(Narra::Storages::Testing.valid?).to be false
    # set test env variable
    ENV['TEST_REQUIREMENT_02'] = 'test'
    # validation
    expect(Narra::Storages::Testing.valid?).to be true
  end

  it 'should have local storage as default' do
    expect(Narra::Storage::SELECTED.identifier).to match(:local)
  end
end