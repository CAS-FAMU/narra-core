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

require 'uri'

module Narra
  module Connectors
    class DirectImage < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :direct_image
      @title = 'Direct Image Connector'
      @description = 'Direct Image Connector uses direct http links to files'

      def self.valid?(url)
        url.start_with?('http://') and (url.end_with?('.jpg') or url.end_with?('.png') or url.end_with?('.gif'))
      end

      def self.resolve(url)
        uri = URI.parse(url)
        name = File.basename(uri.path).split('.').first

        # return proxies
        [{
             url: url,
             name: name,
             thumbnail: nil,
             type: :image,
             connector: @identifier,
             @identifier => {
                 type: :image,
                 name: name
             }
         }]
      end

      def name
        @options[:name]
      end

      def type
        :image
      end

      def metadata
        []
      end

      def thumbnail_url
        @url
      end

      def download_url
        @url
      end
    end
  end
end