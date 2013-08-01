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

describe Narra::Generators::Modules::Generic do
  before(:each) do
    # create item
    @item = FactoryGirl.create(:item, collections: [], owner: @author_user)
  end

  it 'can be instantiated' do
    Narra::Generators::Modules::Generic.new(@item).should be_an_instance_of(Narra::Generators::Modules::Generic)
  end

  it 'should have accessible fields' do
    Narra::Generators::Modules::Generic.identifier.should == :generic
    Narra::Generators::Modules::Generic.title.should == 'Generic'
    Narra::Generators::Modules::Generic.description.should == 'Generic Generator'
  end

  it 'can add metadata to the item' do
    # add meta
    Narra::Generators::Modules::Generic.new(@item).add_meta(name: 'test', content: 'test')
    # validation
    @item.meta.count.should == 1
  end

  it 'can be used to create a new module' do
    Narra::Core.generators.should include(Narra::Generators::Modules::Testing)
  end
end