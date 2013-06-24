#
# This code and everything else included with the R.U.R. Service Core is
# Copyright (c) 2013 rur.cz. All rights reserved. Redistribution of this
# code is prohibited!
#

Rails.application.config.middleware.use OmniAuth::Builder do

  # Developer provider
  if Rails.env.development?
    provider :developer
  end

  # Google apps provider
  provider :open_id, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end