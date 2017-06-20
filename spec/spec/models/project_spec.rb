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

describe Narra::Project do
  it "can be instantiated" do
    expect(FactoryGirl.build(:project)).to be_an_instance_of(Narra::Project)
  end

  it "can be saved successfully" do
    expect(FactoryGirl.create(:project, author: @author_user)).to be_persisted
  end

  it "has public tag set to false" do
    # create project
    project = FactoryGirl.create(:project, author: @author_user)
    # check for meta public tag
    expect(project.get_meta(name: 'public').value).to match('false')
  end
end