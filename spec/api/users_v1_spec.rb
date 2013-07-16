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
        data['message'].should == 'Not Authenticated'
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
        data['message'].should == 'Not Authenticated'
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
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'GET /v1/users/roles' do
      it 'returns all roles' do
        get '/v1/users/roles'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'GET /v1/users/[:id]' do
      it 'returns a specific user' do
        get '/v1/users/' + @unroled_user._id

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'GET /v1/users/[:id]/delete' do
      it 'deletes a specific user' do
        get '/v1/users/' + @unroled_user._id + '/delete'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'POST /v1/users/[:id]/update' do
      it 'updates a specific user' do
        post '/v1/users/' + @unroled_user._id + '/update', { roles: ['author']}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end
  end

  context 'not authorized' do
    describe 'GET /v1/users' do
      it 'returns users' do
        get '/v1/users' + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/users/roles' do
      it 'returns all roles' do
        get '/v1/users/roles' + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/users/[:id]' do
      it 'returns a specific user' do
        get '/v1/users/' + @unroled_user._id + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/users/[:id]/delete' do
      it 'deletes a specific user' do
        get '/v1/users/' + @unroled_user._id + '/delete' + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/users/[:id]/update' do
      it 'updates a specific user' do
        post '/v1/users/' + @unroled_user._id + '/update' + '?token=' + @author_token, { roles: ['author']}

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end
  end

  context 'authenticated & authorized' do
    describe 'GET /v1/users' do
      it 'returns users' do
        # send request
        get '/v1/users' + '?token=' + @admin_token

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
        get '/v1/users/me' + '?token=' + @unroled_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('user')

        # check received data
        data['status'].should == 'OK'
        data['user']['name'].should == @unroled_user.name
        data['user']['email'].should == @unroled_user.email
      end
    end

    describe 'GET /v1/users/me/signout' do
      it 'signouts logged user in the current session' do
        # send request
        get '/v1/users/me/signout' + '?token=' + @unroled_token

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
        get '/v1/users/' + @admin_user._id + '?token=' + @admin_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('user')

        # check received data
        data['status'].should == 'OK'
        data['user']['name'].should == @admin_user.name
        data['user']['email'].should == @admin_user.email
        data['user']['roles'].collect {|role| role.to_sym}.should == @admin_user.roles
      end
    end

    describe 'GET /v1/users/[:id]/delete' do
      it 'deletes a specific user' do
        # send request
        get '/v1/users/' + @unroled_user._id + '/delete' + '?token=' + @admin_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'

        # check if the user is deleted
        User.find(@unroled_user._id).should == nil
      end
    end
  end
end