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

describe Narra::Synthesizers::Worker do
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

  it 'should process project to generate new junction' do
    # generate through main process
    Narra::Synthesizers::Worker.perform_async(project: @project._id.to_s, identifier: :testing, event: @event._id.to_s)
    # validation
    expect(@project.junctions.count).to match(1)
  end
end