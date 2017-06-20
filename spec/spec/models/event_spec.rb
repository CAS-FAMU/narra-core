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

describe Narra::Event do
  it "can be instantiated" do
    expect(FactoryGirl.build(:event)).to be_an_instance_of(Narra::Event)
  end

  it "can be saved successfully" do
    expect(FactoryGirl.create(:event)).to be_persisted
  end

  it "should be in pending state" do
    # create an event
    expect(FactoryGirl.create(:event)).to be_persisted
    # check state
    expect(Narra::Event.first.pending?).to be_truthy
  end

  it "can be run successfully" do
    # create an event
    expect(FactoryGirl.create(:event)).to be_persisted
    # check state
    expect(Narra::Event.first.pending?).to be_truthy
    # run
    Narra::Event.first.run!
    # check state
    expect(Narra::Event.first.running?).to be_truthy
  end

  it "can be successfully finished" do
    # create an event
    expect(FactoryGirl.create(:event)).to be_persisted
    # check state
    expect(Narra::Event.first.pending?).to be_truthy
    # run
    Narra::Event.first.run!
    Narra::Event.first.done!
    # check event existence
    expect(Narra::Event.all.count).to match(0)
  end
end