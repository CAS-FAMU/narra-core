#
# Copyright (C) 2015 CAS / FAMU
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

require 'viddl-rb'

module Narra
  module Connectors
    class Youtube < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :youtube
      @title = 'YouTube Connector'
      @description = 'YouTube Connector uses viddl-rb'

      def self.valid?(url)
        (url.start_with?('http') or url.start_with?('https')) and url.include?('youtube.com') and url.include?('watch')
      end

      def self.resolve(url)
        # parse url
        data = ViddlRb.get_urls_names(url).first
        download_url = data[:url]
        name = data[:name].split('.').first

        # return proxies
        [{
             url: url,
             name: name,
             thumbnail: nil,
             type: :video,
             connector: @identifier,
             @identifier => {
                 download_url: download_url,
                 name: name
             }
         }]
      end

      def initialization
        # prepare download url
        @download_url = @options[:download_url]

        # prepare metadata
        @metadata = []
      end

      def name
        @options[:name]
      end

      def type
        :video
      end

      def metadata
        @metadata
      end

      def download_url
        @download_url
      end
    end
  end
end