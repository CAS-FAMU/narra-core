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

describe Event do
  it "can be instantiated" do
    FactoryGirl.build(:event).should be_an_instance_of(Event)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:event).should be_persisted
  end

  it "should be in pending state" do
    # create an event
    FactoryGirl.create(:event).should be_persisted
    # check state
    Event.first.pending?.should be_true
  end

  it "can be run successfully" do
    # create an event
    FactoryGirl.create(:event).should be_persisted
    # check state
    Event.first.pending?.should be_true
    # run
    Event.first.run!
    # check state
    Event.first.running?.should be_true
  end

  it "can be successfully finished" do
    # create an event
    FactoryGirl.create(:event).should be_persisted
    # check state
    Event.first.pending?.should be_true
    # run
    Event.first.run!
    Event.first.done!
    # check event existence
    Event.all.count.should == 0
  end
end