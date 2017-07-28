#
# Copyright (C) 2017 CAS / FAMU
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
  module Defaults
    class Video < Narra::SPI::Default

      # Default values
      @identifier = :video

      def self.settings
        {
            video_proxy_extension: 'mp4',
            video_proxy_lq_resolution: '320x180',
            video_proxy_lq_bitrate: '300',
            video_proxy_hq_resolution: '1280x720',
            video_proxy_hq_bitrate: '1000',
        }
      end
    end
  end
end