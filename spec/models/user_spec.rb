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

describe User do
  it "can be instantiated" do
    FactoryGirl.build(:user).should be_an_instance_of(User)
  end

  it "can be saved successfully" do
    FactoryGirl.create(:user).should be_persisted
  end

  it "creates from hash" do
    # testing hash
    hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"tester@narra.eu","info":{"name":"Tester","email":"tester@narra.eu"},"credentials":{},"extra":{}}')

    # call method
    user = User.create_from_hash!(hash)

    # expect
    expect(User.first).to eq(user)
  end
end