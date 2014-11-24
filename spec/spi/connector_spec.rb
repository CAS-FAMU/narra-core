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

require 'spec_helper'

describe Narra::SPI::Connector do
  before(:each) do
    # test url
    @url = 'http://test'
  end

  it 'can be instantiated' do
    expect(Narra::SPI::Connector.new(@url)).to be_an_instance_of(Narra::SPI::Connector)
  end

  it 'should have accessible fields' do
    expect(Narra::SPI::Connector.identifier).to match(:generic)
    expect(Narra::SPI::Connector.title).to match('Generic')
    expect(Narra::SPI::Connector.description).to match('Generic Connector')
  end
end