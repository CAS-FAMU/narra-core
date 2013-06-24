#
# This code and everything else included with the R.U.R. Service Core is
# Copyright (c) 2013 rur.cz. All rights reserved. Redistribution of this
# code is prohibited!
#

module API
  module Modules
    class Authentication < Grape::API

      format :json

      helpers API::Helpers::User

      resource :auth do
        post '/:provider/callback' do
          auth = request.env['omniauth.auth']

          unless @auth = Identity.find_from_hash(auth)
            # Create a new user or add an auth to existing user, depending on
            # whether there is already a user signed in.
            @auth = Identity.create_from_hash(auth, User.where(email: auth.info.email).first)
          end

          cookies[:_narra_core_token] = {
              :value => @token ||= Base64.urlsafe_encode64(auth.uid),
              :path => '/'
          }

          # get back to origin path or return token
          if request.env['omniauth.origin']
            redirect request.env['omniauth.origin'], :permanent => true
          end

          # return token in json when request is not from browser
          { _narra_core_token: @token }
        end

        get '/providers/active' do
          { name: Tools::Settings.auth_providers_active }
        end
      end
    end
  end
end