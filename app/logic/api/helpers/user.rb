#
# This code and everything else included with the R.U.R. Service Core is
# Copyright (c) 2013 rur.cz. All rights reserved. Redistribution of this
# code is prohibited!
#

module API
  module Helpers
    module User
      def authenticate!
        error!('Unauthenticated. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        # check for token presence
        return nil if cookies[:_narra_core_token].nil?

        # get identity for token
        identity = Identity.where(uid: Base64.urlsafe_decode64(cookies[:_narra_core_token])).first

        # signout in case non existing identity
        return nil && signout if identity.nil?

        # get user from token
        @current_user ||= identity.user
      end

      def signout
        # clean current user
        @current_user = nil
        # delete token
        cookies.delete :_narra_core_token, :path => '/'
      end
    end
  end
end