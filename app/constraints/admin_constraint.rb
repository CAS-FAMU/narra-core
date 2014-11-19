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
# Authors: Michal Mocnak <michal@marigan.net>
#

class AdminConstraint

  def self.matches?(request)
    # check for token presence
    return false if request.params[:token].nil? && request.session[:token].nil?

    begin
      # set token to session
      request.session[:token] = request.params[:token] unless request.params[:token].nil?

      # get uid
      uid = Base64::urlsafe_decode64(request.session[:token])

      # get identity for token
      identity = Identity.where(uid: uid).first

      # signout in case non existing identity
      raise if identity.nil?

      # get user from token
      return identity.user.is?([:admin])
    rescue
      return false
    end
  end
end