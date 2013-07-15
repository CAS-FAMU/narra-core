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

describe API::Modules::ProjectsV1 do
  before(:each) do
    # testing hash
    hash = ActiveSupport::JSON.decode('{"provider":"test","uid":"tester@narra.eu","info":{"name":"Tester","email":"tester@narra.eu"},"credentials":{},"extra":{}}')
    # create user and its identity
    Identity.create_from_hash(hash)
    # get token and user
    @token = CGI::escape(Base64.urlsafe_encode64(hash['uid']))
    @user = User.first

    # create collection
    @collection_01 = FactoryGirl.create(:collection, owner: @user)
    @collection_02 = FactoryGirl.create(:collection, owner: @user)
    @collection_03 = FactoryGirl.create(:collection, owner: @user)
    @collection_04 = FactoryGirl.create(:collection, owner: @user)

    # create projects for testing purpose
    @project = FactoryGirl.create(:project, owner: @user, collections: [@collection_01, @collection_02])
    FactoryGirl.create(:project, owner: @user)
  end

  context 'not authenticated' do
    describe 'GET /v1/projects' do
      it 'returns projects' do
        get '/v1/projects'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        get '/v1/projects/' + @project.name

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        get '/v1/projects/' + @project.name + '/delete'

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        post '/v1/projects/new', {name: '', title: ''}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'updates a specific project' do
        post '/v1/projects/' + @project.name + '/update', {title: ''}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/projects/[:name]/add' do
      it 'adds specific collections' do
        post '/v1/projects/' + @project.name + '/add', {collections: [@collection_03.name]}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Access Denied'
      end
    end

    describe 'POST /v1/projects/[:name]/remove' do
      it 'removes specific collections' do
        post '/v1/projects/' + @project.name + '/remove', {collections: [@collection_01.name]}

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
    describe 'GET /v1/projects' do
      it 'returns projects' do
        # send request
        get '/v1/projects' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('projects')

        # check received data
        data['status'].should == 'OK'
        data['projects'].count.should == 2
      end
    end

    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        # send request
        get '/v1/projects/' + @project.name + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('project')

        # check received data
        data['status'].should == 'OK'
        data['project']['name'].should == @project.name
        data['project']['title'].should == @project.title
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        # send request
        get '/v1/projects/' + @project.name + '/delete' + '?token=' + @token

        # check response status
        response.status.should == 200

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')

        # check received data
        data['status'].should == 'OK'

        # check if the user is deleted
        Project.find(@project._id).should == nil
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        # send request
        post '/v1/projects/new' + '?token=' + @token, {name: 'test_project', title: 'Test Project'}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('project')

        # check received data
        data['status'].should == 'OK'
        data['project']['name'].should == 'test_project'
        data['project']['title'].should == 'Test Project'
        data['project']['owner']['name'].should == @user.name
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'creates new project' do
        # send request
        post '/v1/projects/' + @project.name + '/update' + '?token=' + @token, {title: 'Test Project Updated'}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('project')

        # check received data
        data['status'].should == 'OK'
        data['project']['name'].should == @project.name
        data['project']['title'].should == 'Test Project Updated'
        data['project']['owner']['name'].should == @user.name
      end
    end

    describe 'POST /v1/projects/[:name]/add' do
      it 'adds specific collections' do
        # send request
        post '/v1/projects/' + @project.name + '/add' + '?token=' + @token, {collections: [@collection_03.name, @collection_04.name]}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('project')

        # check received data
        data['status'].should == 'OK'
        data['project']['name'].should == @project.name
        data['project']['collections'].count.should == 4
      end
    end

    describe 'POST /v1/projects/[:name]/remove' do
      it 'removes specific collections' do
        # send request
        post '/v1/projects/' + @project.name + '/remove' + '?token=' + @token, {collections: [@collection_01.name, @collection_02.name]}

        # check response status
        response.status.should == 201

        # parse response
        data = JSON.parse(response.body)

        # check received data format
        data.should have_key('status')
        data.should have_key('project')

        # check received data
        data['status'].should == 'OK'
        data['project']['name'].should == @project.name
        data['project']['collections'].count.should == 0
      end
    end
  end
end