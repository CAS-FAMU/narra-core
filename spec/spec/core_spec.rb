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

describe Narra::Core do
  before do
    # create scenarios
    @scenario_project = FactoryBot.create(:scenario_project, author: @author_user)
    @scenario_library = FactoryBot.create(:scenario_library, author: @author_user)
    # create project
    @project = FactoryBot.create(:project, author: @author_user, scenario: @scenario_project)
    # create library
    @library = FactoryBot.create(:library, author: @author_user, scenario: @scenario_library, projects: [@project])
    # create item
    @item = FactoryBot.create(:item, library: @library)
    # create item prepared
    @item_prepared= FactoryBot.create(:item_prepared, library: @library)
  end

  it 'should return all active generators' do
    expect(Narra::Core.generators.count).to match(1)
  end

  it 'should return all active synthesizers' do
    expect(Narra::Core.synthesizers.count).to match(2)
  end

  it 'should process item to generate new metadata' do
    # generate through main process with non prepared item
    Narra::Core.generate(@item, [:testing])
    # generate through main process with prepared item
    Narra::Core.generate(@item_prepared, [:testing])
    # validation
    expect(@item.meta.count).to match(0)
    expect(@item_prepared.meta.count).to match(0)
    # assign testing generator to library
    @library.scenario.generators << {identifier: 'testing', options: {}}
    # regenerate
    Narra::Core.generate(@item, [:testing])
    Narra::Core.generate(@item_prepared, [:testing])
    # validation
    expect(@item.meta.count).to match(0)
    expect(@item_prepared.meta.count).to match(1)
  end

  it 'should process item to generate new junction' do
    # add synthesizer to the project
    @project.scenario.synthesizers << {identifier: 'testing', options: {}}
    # synthesize
    Narra::Core.synthesize(@project, [:testing])
    # validation
    expect(@project.junctions.count).to match(1)
  end
end