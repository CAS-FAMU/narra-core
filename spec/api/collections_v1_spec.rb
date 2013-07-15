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

describe API::Modules::CollectionsV1 do
  before(:each) do
    # testing hash
    hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"tester@narra.eu","info":{"name":"Tester","email":"tester@narra.eu"},"credentials":{},"extra":{}}')
    # create user and its identity
    Identity.create_from_hash(hash)
    # get token and user
    @token = CGI::escape(Base64.urlsafe_encode64(hash['uid']))
    @user = User.first

    # create collection
    @collection = FactoryGirl.create(:collection, owner: @user)
    FactoryGirl.create(:collection, owner: @user)
    FactoryGirl.create(:collection, owner: @user)
    FactoryGirl.create(:collection, owner: @user)
  end

  context 'not authenticated' do
    describe 'GET /v1/colletions' do
      it 'returns collections' do
        get '/v1/collections'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/collections/[:name]' do
      it 'returns a specific collection' do
        get '/v1/collections/' + @collection.name

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/collections/[:name]/delete' do
      it 'deletes a specific collection' do
        get '/v1/collections/' + @collection.name + '/delete'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/collections/new' do
      it 'creates new collection' do
        post '/v1/collections/new', {name: '', title: ''}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/collections/[:name]/update' do
      it 'updates specific collection' do
        post '/v1/collections/' + @collection.name + '/update', {title: ''}

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
    describe 'GET /v1/colletions' do
      it 'returns collections' do
        # send request
        get '/v1/collections' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('collections')

        # check received data
        data['status'].should == 'OK'
        data['collections'].count.should == 4
      end
    end

    describe 'GET /v1/collections/[:name]' do
      it 'returns a specific collection' do
        # send request
        get '/v1/collections/' + @collection.name + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('collection')

        # check received data
        data['status'].should == 'OK'
        data['collection']['name'].should == @collection.name
        data['collection']['title'].should == @collection.title
      end
    end

    describe 'GET /v1/collections/[:name]/delete' do
      it 'deletes a specific collection' do
        # send request
        get '/v1/collections/' + @collection.name + '/delete' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'

        # check if the user is deleted
        Collection.find(@collection._id).should == nil
      end
    end

    describe 'POST /v1/collections/new' do
      it 'creates new collection' do
        # send request
        post '/v1/collections/new' + '?token=' + @token, {name: 'test_collection', title: 'Test Collection'}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('collection')

        # check received data
        data['status'].should == 'OK'
        data['collection']['name'].should == 'test_collection'
        data['collection']['title'].should == 'Test Collection'
        data['collection']['owner']['name'].should == @user.name
      end
    end

    describe 'POST /v1/collections/[:name]/update' do
      it 'updates specific collection' do
        # send request
        post '/v1/collections/' + @collection.name + '/update' + '?token=' + @token, {title: 'Test Collection Updated'}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('collection')

        # check received data
        data['status'].should == 'OK'
        data['collection']['name'].should == @collection.name
        data['collection']['title'].should == 'Test Collection Updated'
        data['collection']['owner']['name'].should == @user.name
      end
    end
  end
end