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

class Video < Item

  # Helper methods
  def proxy_lq
    @proxy_lq_file ||= storage.files.get(_id.to_s + '_proxy_lq.' + Narra::Tools::Settings.video_proxy_extension)
  end

  def proxy_hq
    @proxy_hq_file ||= storage.files.get(_id.to_s + '_proxy_hq.' + Narra::Tools::Settings.video_proxy_extension)
  end

  def url_proxy_lq
    proxy_lq.public_url
  end

  def url_proxy_hq
    proxy_hq.public_url
  end

  def prepared?
    !proxy_hq.nil? && !proxy_lq.nil?
  end
end