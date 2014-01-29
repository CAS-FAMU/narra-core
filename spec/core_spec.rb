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

describe Narra::Core do
  before(:each) do
    # create item
    @item = FactoryGirl.create(:item, collections: [], owner: @author_user)
    @item_out = FactoryGirl.create(:item, collections: [], owner: @author_user)
    # create project
    @project = FactoryGirl.create(:project, owner: @author_user)
  end

  it 'should return all active generators' do
    Narra::Core.generators.count.should == 4
  end

  it 'should return all active synthesizers' do
    Narra::Core.synthesizers.count.should == 1
  end

  it 'should process item to generate new metadata' do
    # generate through main process
    Narra::Core.generate(@item, [:testing])
    # validation
    @item.meta.count.should == 1
  end

  it 'should process item to generate new junction' do
    # generate through main process
    Narra::Core.synthesize(@item, @project, [:testing])
    # validation
    @project.junctions.count.should == 1
  end
end