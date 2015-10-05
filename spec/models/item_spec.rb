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

describe Narra::Item do
  it 'can be instantiated' do
    expect(FactoryGirl.build(:item)).to be_an_instance_of(Narra::Item)
  end

  it 'can be saved successfully' do
    expect(FactoryGirl.create(:item)).to be_persisted
  end

  it 'should process item to generate new metadata' do
    # create library
    @library = FactoryGirl.create(:library, author: @author_user, generators: [{identifier:'testing', options:{}}], projects: [])
    # create item prepared
    @item_prepared= FactoryGirl.create(:item_prepared, library: @library)
    # generate
    @item_prepared.generate
    # validation
    expect(@item_prepared.meta.count).to match(1)
  end
end