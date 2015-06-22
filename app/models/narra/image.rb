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

module Narra
  class Image < Item

    # define image proxy object / transcoding process
    mount_uploader :image, Narra::ImageProxyUploader

    # define thumbnail
    embeds_one :thumbnail, class_name: 'Narra::Thumbnail', cascade_callbacks: true

    def prepared?
      !image_proxy_hq.url.nil? && !image_proxy_lq.url.nil?
    end
  end
end