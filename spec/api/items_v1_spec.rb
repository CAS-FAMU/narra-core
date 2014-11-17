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

describe Narra::API::Modules::ItemsV1 do
  before(:each) do
    # create collection
    @collection_01 = FactoryGirl.create(:collection, owner: @author_user)
    @collection_02 = FactoryGirl.create(:collection, owner: @author_user)

    # create metadata
    @meta_src_01 = FactoryGirl.create(:meta, :source)
    @meta_src_02 = FactoryGirl.create(:meta, :source)

    # create items
    @item = FactoryGirl.create(:item, collections: [@collection_01], owner: @author_user)
    @item_admin = FactoryGirl.create(:item, collections: [@collection_02], owner: @admin_user)
    @item_meta = FactoryGirl.create(:item, collections: [@collection_02], meta: [@meta_src_01, @meta_src_02], owner: @author_user)

    # create events
    @event = FactoryGirl.create(:event, item: @item)
  end

  context 'not authenticated' do
    describe 'GET /v1/items' do
      it 'returns items' do
        get '/v1/items'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        get '/v1/items/' + @item.name

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        get '/v1/items/' + @item.name + '/delete'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        post '/v1/items/new', {url: 'test', collection: 'test'}

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/items/[:name]/events' do
      it 'returns item events' do
        get '/v1/items/' + @item.name + '/events'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end
  end

  context 'not authorized' do
    describe 'GET /v1/items' do
      it 'returns items' do
        get '/v1/items' + '?token=' + @unroled_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        get '/v1/items/' + @item.name + '?token=' + @unroled_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        get '/v1/items/' + @item_admin.name + '/delete' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        post '/v1/items/new' + '?token=' + @unroled_token, {url: 'test', collection: 'test'}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/items/[:name]/events' do
      it 'returns item events' do
        get '/v1/items/' + @item_admin.name + '/events?token=' + @author_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end
  end

  context 'authenticated & authorized' do
    describe 'GET /v1/items' do
      it 'returns items' do
        # send request
        get '/v1/items' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('items')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['items'].count).to match(3)
      end
    end

    describe 'GET /v1/items/[:name]' do
      it 'returns a specific item' do
        # send request
        get '/v1/items/' + @item_meta.name + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('item')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['item']['name']).to match(@item_meta.name)
        expect(data['item']['url']).to match(@item_meta.url)
        expect(data['item']['metadata'].count).to match(2)
      end
    end

    describe 'GET /v1/items/[:name]/delete' do
      it 'deletes a specific item' do
        # send request
        get '/v1/items/' + @item.name + '/delete' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')

        # check received data
        expect(data['status']).to match('OK')

        # check if the user is deleted
        expect(Item.find(@item._id)).to be_nil
      end
    end

    describe 'POST /v1/items/new' do
      it 'creates new item' do
        # send request
        post '/v1/items/new' + '?token=' + @author_token, {url: 'http://test', collection: @collection_01._id.to_s, metadata: {meta_01: 'Meta 01', meta_02: 'Meta 02'}}

        # check response status
        expect(response.status).to match(201)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('item')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['item']['name']).to match('test_item')
        expect(data['item']['url']).to match('http://test')
        expect(data['item']['metadata'].count).to match(9)
      end
    end

    describe 'GET /v1/items/[:name]/events' do
      it 'returns item events' do
        get '/v1/items/' + @item.name + '/events?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('events')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['events'].count).to match(1)
        expect(data['events'][0]['status']).to match('pending')
      end
    end
  end
end