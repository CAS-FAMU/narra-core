#
# Copyright (C) 2014 CAS / FAMU
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

describe Narra::API::Modules::CollectionsV1 do
  before(:each) do
    # create items
    @item_01 = FactoryGirl.create(:item, owner: @author_user)
    @item_02 = FactoryGirl.create(:item, owner: @author_user)

    # create collection
    @collection = FactoryGirl.create(:collection, owner: @author_user)
    @collection_admin = FactoryGirl.create(:collection, owner: @admin_user)
    @collection_items = FactoryGirl.create(:collection, owner: @author_user, items: [@item_01, @item_02])
  end

  context 'not authenticated' do
    describe 'GET /v1/colletions' do
      it 'returns collections' do
        get '/v1/collections'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/collections/[:name]' do
      it 'returns a specific collection' do
        get '/v1/collections/' + @collection.name

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/collections/[:name]/items' do
      it 'returns a specific collection items' do
        get '/v1/collections/' + @collection.name + '/items'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'GET /v1/collections/[:name]/delete' do
      it 'deletes a specific collection' do
        get '/v1/collections/' + @collection.name + '/delete'

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'POST /v1/collections/new' do
      it 'creates new collection' do
        post '/v1/collections/new', {name: 'test', title: 'test'}

        # check response status
        expect(response.status).to match(401)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authenticated')
      end
    end

    describe 'POST /v1/collections/[:name]/update' do
      it 'updates specific collection' do
        post '/v1/collections/' + @collection.name + '/update', {title: 'test'}

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
    describe 'GET /v1/colletions' do
      it 'returns collections' do
        get '/v1/collections' + '?token=' + @unroled_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/collections/[:name]' do
      it 'returns a specific collection' do
        get '/v1/collections/' + @collection.name + '?token=' + @unroled_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'GET /v1/collections/[:name]/items' do
      it 'returns a specific collection items' do
        get '/v1/collections/' + @collection.name + '/items?token=' + @unroled_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end


    describe 'GET /v1/collections/[:name]/delete' do
      it 'deletes a specific collection' do
        get '/v1/collections/' + @collection_admin.name + '/delete' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'POST /v1/collections/new' do
      it 'creates new collection' do
        post '/v1/collections/new' + '?token=' + @unroled_token, {name: 'test', title: 'test'}

        # check response status
        expect(response.status).to match(403)

        # parse response
        data = JSON.parse(response.body)

        # check received data
        expect(data['status']).to match('ERROR')
        expect(data['message']).to match('Not Authorized')
      end
    end

    describe 'POST /v1/collections/[:name]/update' do
      it 'updates specific collection' do
        post '/v1/collections/' + @collection_admin.name + '/update' + '?token=' + @author_token, {title: 'test'}

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
    describe 'GET /v1/colletions' do
      it 'returns collections' do
        # send request
        get '/v1/collections' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('collections')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['collections'].count).to match(3)
      end
    end

    describe 'GET /v1/collections/[:name]' do
      it 'returns a specific collection' do
        # send request
        get '/v1/collections/' + @collection.name + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('collection')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['collection']['name']).to match(@collection.name)
        expect(data['collection']['title']).to match(@collection.title)
      end
    end

    describe 'GET /v1/collections/[:name]/items' do
      it 'returns a specific collection items' do
        # send request
        get '/v1/collections/' + @collection_items.name + '/items?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('items')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['items'].count).to match(2)
      end
    end

    describe 'GET /v1/collections/[:name]/delete' do
      it 'deletes a specific collection' do
        # send request
        get '/v1/collections/' + @collection.name + '/delete' + '?token=' + @author_token

        # check response status
        expect(response.status).to match(200)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')

        # check received data
        expect(data['status']).to match('OK')

        # check if the user is deleted
        expect(Collection.find(@collection._id)).to be_nil
      end
    end

    describe 'POST /v1/collections/new' do
      it 'creates new collection' do
        # send request
        post '/v1/collections/new' + '?token=' + @author_token, {name: 'test_collection', title: 'Test Collection', description: 'Test Collection Description'}

        # check response status
        expect(response.status).to match(201)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('collection')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['collection']['name']).to match('test_collection')
        expect(data['collection']['title']).to match('Test Collection')
        expect(data['collection']['description']).to match('Test Collection Description')
        expect(data['collection']['owner']['name']).to match(@author_user.name)
      end
    end

    describe 'POST /v1/collections/[:name]/update' do
      it 'updates specific collection' do
        # send request
        post '/v1/collections/' + @collection.name + '/update' + '?token=' + @author_token, {title: 'Test Collection Updated', description: 'Test Collection Description Updated'}

        # check response status
        expect(response.status).to match(201)

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        expect(data).to have_key('status')
        expect(data).to have_key('collection')

        # check received data
        expect(data['status']).to match('OK')
        expect(data['collection']['name']).to match(@collection.name)
        expect(data['collection']['title']).to match('Test Collection Updated')
        expect(data['collection']['description']).to match('Test Collection Description Updated')
        expect(data['collection']['owner']['name']).to match(@author_user.name)
      end
    end
  end
end