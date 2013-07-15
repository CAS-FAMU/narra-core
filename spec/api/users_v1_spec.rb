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

describe API::Modules::UsersV1 do
  before(:each) do
    # testing hash
    hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"tester@narra.eu","info":{"name":"Tester","email":"tester@narra.eu"},"credentials":{},"extra":{}}')
    # create user and its identity
    Identity.create_from_hash(hash)
    # get token and user
    @token = CGI::escape(Base64.urlsafe_encode64(hash['uid']))
    @user = User.first

    # create other users for testing purpose
    FactoryGirl.create(:user)
    FactoryGirl.create(:user)
  end

  context 'not authenticated' do
    describe 'GET /v1/users' do
      it 'returns users' do
        get '/v1/users'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/users/me' do
      it 'returns logged user in the current session' do
        get '/v1/users/me'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/users/me/signout' do
      it 'signouts logged user in the current session' do
        get '/v1/users/me/signout'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/users/[:id]' do
      it 'returns a specific user' do
        get '/v1/users/' + @user._id

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/users/[:id]/delete' do
      it 'deletes a specific user' do
        get '/v1/users/' + @user._id + '/delete'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end
  end

  context 'authenticated' do
    describe 'GET /v1/users' do
      it 'returns users' do
        # send request
        get '/v1/users' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('users')

        # check received data
        data['status'].should == 'OK'
        data['users'].count.should == 3
      end
    end

    describe 'GET /v1/users/me' do
      it 'returns logged user in the current session' do
        # send request
        get '/v1/users/me' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('user')

        # check received data
        data['status'].should == 'OK'
        data['user']['name'].should == @user.name
        data['user']['email'].should == @user.email
      end
    end

    describe 'GET /v1/users/me/signout' do
      it 'signouts logged user in the current session' do
        # send request
        get '/v1/users/me/signout' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'
      end
    end

    describe 'GET /v1/users/[:id]' do
      it 'returns a specific user' do
        # send request
        get '/v1/users/' + @user._id + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('user')

        # check received data
        data['status'].should == 'OK'
        data['user']['name'].should == @user.name
        data['user']['email'].should == @user.email
      end
    end

    describe 'GET /v1/users/[:id]/delete' do
      it 'deletes a specific user' do
        # send request
        get '/v1/users/' + @user._id + '/delete' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'

        # check if the user is deleted
        User.find(@user._id).should == nil
      end
    end
  end
end