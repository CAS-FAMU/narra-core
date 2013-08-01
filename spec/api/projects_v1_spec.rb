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

describe Narra::API::Modules::ProjectsV1 do
  before(:each) do
    # create collection
    @collection_01 = FactoryGirl.create(:collection, owner: @author_user)
    @collection_02 = FactoryGirl.create(:collection, owner: @author_user)
    @collection_03 = FactoryGirl.create(:collection, owner: @author_user)
    @collection_04 = FactoryGirl.create(:collection, owner: @author_user)

    # create projects for testing purpose
    @project = FactoryGirl.create(:project, owner: @author_user, collections: [@collection_01, @collection_02])
    @project_admin = FactoryGirl.create(:project, owner: @admin_user, collections: [@collection_03, @collection_04])
  end

  context 'not authenticated' do
    describe 'GET /v1/projects' do
      it 'returns projects' do
        get '/v1/projects'

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
        get '/v1/projects/' + @project.name

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
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
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        post '/v1/projects/new', {name: 'test', title: 'test'}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'updates a specific project' do
        post '/v1/projects/' + @project.name + '/update', {title: 'test'}

        # check response status
        response.status.should == 401

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authenticated'
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
        data['message'].should == 'Not Authenticated'
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
        data['message'].should == 'Not Authenticated'
      end
    end
  end

  context 'not authorized' do
    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        get '/v1/projects/' + @project_admin.name + '?token=' + @author_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'GET /v1/projects/[:name]/delete' do
      it 'deletes a specific project' do
        get '/v1/projects/' + @project.name + '/delete' + '?token=' + @unroled_token

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/projects/new' do
      it 'creates new project' do
        post '/v1/projects/new' + '?token=' + @unroled_token, {name: 'test', title: 'test'}

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'updates a specific project' do
        post '/v1/projects/' + @project_admin.name + '/update' + '?token=' + @author_token, {title: 'test'}

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/projects/[:name]/add' do
      it 'adds specific collections' do
        post '/v1/projects/' + @project_admin.name + '/add' + '?token=' + @author_token, {collections: [@collection_01.name]}

        # check response status
        response.status.should == 403

        # parse response
        data = JSON.parse(response.body)

        # check received data
        data['status'].should == 'ERROR'
        data['message'].should == 'Not Authorized'
      end
    end

    describe 'POST /v1/projects/[:name]/remove' do
      it 'removes specific collections' do
        post '/v1/projects/' + @project_admin.name + '/remove' + '?token=' + @author_token, {collections: [@collection_03.name]}

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
    describe 'GET /v1/projects/[:name]' do
      it 'returns a specific project' do
        # send request
        get '/v1/projects/' + @project.name + '?token=' + @author_token

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
        get '/v1/projects/' + @project.name + '/delete' + '?token=' + @author_token

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
        post '/v1/projects/new' + '?token=' + @author_token, {name: 'test_project', title: 'Test Project'}

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
        data['project']['owner']['name'].should == @author_user.name
      end
    end

    describe 'POST /v1/projects/[:name]/update' do
      it 'creates new project' do
        # send request
        post '/v1/projects/' + @project.name + '/update' + '?token=' + @author_token, {title: 'Test Project Updated'}

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
        data['project']['owner']['name'].should == @author_user.name
      end
    end

    describe 'POST /v1/projects/[:name]/add' do
      it 'adds specific collections' do
        # send request
        post '/v1/projects/' + @project.name + '/add' + '?token=' + @author_token, {collections: [@collection_03.name, @collection_04.name]}

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
        post '/v1/projects/' + @project.name + '/remove' + '?token=' + @author_token, {collections: [@collection_01.name, @collection_02.name]}

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