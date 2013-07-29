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

describe API::Modules::ItemsV1 do
  before(:each) do
    # create collection
    @collection_01 = FactoryGirl.create(:collection, owner: @author_user)
    @collection_02 = FactoryGirl.create(:collection, owner: @author_user)

    # create metadata
    @meta_src_01 = FactoryGirl.create(:meta, :source)
    @meta_src_02 = FactoryGirl.create(:meta, :source)

    # create collection
    @item = FactoryGirl.create(:item, collections: [@collection_01], owner: @author_user)
    @item_admin = FactoryGirl.create(:item, collections: [@collection_02], owner: @admin_user)
    @item_meta = FactoryGirl.create(:item, collections: [@collection_02], meta: [@meta_src_01, @meta_src_02], owner: @author_user)
  end

  context 'not authenticated' do
    describe 'GET /v1/items' do
      it 'returns items' do
        get '/v1/items'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        get '/v1/items/' + @item.name

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        get '/v1/items/' + @item.name + '/delete'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        post '/v1/items/new', {name: '', url: '', collection: ''}

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
    describe 'GET /v1/items' do
      it 'returns items' do
        get '/v1/items' + '?token=' + @unroled_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        get '/v1/items/' + @item.name + '?token=' + @unroled_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        get '/v1/items/' + @item_admin.name + '/delete' + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        post '/v1/items/new' + '?token=' + @unroled_token, {name: '', url: '', collection: ''}

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
    describe 'GET /v1/items' do
      it 'returns items' do
        # send request
        get '/v1/items' + '?token=' + @author_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('items')

        # check received data
        data['status'].should == 'OK'
        data['items'].count.should == 3
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        # send request
        get '/v1/items/' + @item_meta.name + '?token=' + @author_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('item')

        # check received data
        data['status'].should == 'OK'
        data['item']['name'].should == @item_meta.name
        data['item']['url'].should == @item_meta.url
        data['item']['metadata'].count.should == 2
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        # send request
        get '/v1/items/' + @item.name + '/delete' + '?token=' + @author_token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'

        # check if the user is deleted
        Item.find(@item._id).should == nil
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        # send request
        post '/v1/items/new' + '?token=' + @author_token, {name: 'test_item', url: 'url://test_item', collection: @collection_01.name, metadata: {meta_01: 'Meta 01', meta_02: 'Meta 02'}}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('item')

        # check received data
        data['status'].should == 'OK'
        data['item']['name'].should == 'test_item'
        data['item']['url'].should == 'url://test_item'
        data['item']['metadata'].count.should == 2
      end
    end
  end
end