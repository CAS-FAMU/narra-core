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

describe Narra::User do
  it "can be instantiated" do
    expect(FactoryGirl.build(:user)).to be_an_instance_of(Narra::User)
  end

  it "can be saved successfully" do
    expect(FactoryGirl.create(:user)).to be_persisted
  end

  it "creates from hash" do
    # expect 3 users as far as we are using create_from_hash in the spec_helper
    expect(Narra::User.all.count).to match(3)
  end
end