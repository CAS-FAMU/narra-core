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

describe Narra::Synthesizers::Modules::Generic do
  before(:each) do
    # create project
    @project = FactoryGirl.create(:project, owner: @author_user)
    # create collection
    @collection = FactoryGirl.create(:collection, owner: @author_user, projects: [@project])
    # create item
    @item = FactoryGirl.create(:item, collections: [@collection], owner: @author_user)
    # create event
    @event = FactoryGirl.create(:event, project: @project)
  end

  it 'can be instantiated' do
    Narra::Synthesizers::Modules::Generic.new(@project, @event).should be_an_instance_of(Narra::Synthesizers::Modules::Generic)
  end

  it 'should have accessible fields' do
    Narra::Synthesizers::Modules::Generic.identifier.should == :generic
    Narra::Synthesizers::Modules::Generic.title.should == 'Generic'
    Narra::Synthesizers::Modules::Generic.description.should == 'Generic Synthesizer'
  end

  it 'can add junction to the project' do
    # add meta
    Narra::Synthesizers::Modules::Generic.new(@project, @event).add_junction(weight: 1.0, out: @item)
    # validation
    @project.junctions.count.should == 1
  end

  it 'can be used to create a new module' do
    Narra::Core.synthesizers.should include(Narra::Synthesizers::Modules::Testing)
  end
end