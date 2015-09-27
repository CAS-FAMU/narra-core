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

require 'uri'

module Narra
  module Connectors
    class ArchiveOrg < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :archiveorg
      @title = 'Archive.org Connector'
      @description = 'Archive.org Connector uses json API'

      def self.valid?(url)
        url.start_with?('http') and url.include?('archive.org')
      end

      def self.resolve(url)
        # parse url
        uri = URI.parse(url)
        name = File.basename(uri.path).split('.').first

        # get metadata
        arch_metadata = JSON.load(open("https://archive.org/metadata/#{name}"))
        arch_server = 'http://' + arch_metadata['d1'] + arch_metadata['dir'] + '/'

        # resolve all media
        arch_media = arch_metadata['files'].select { |f| f['source'] == 'original' and f['format'] != 'Metadata' }

        # prepare connectors container
        proxies = []

        # create connectors
        arch_media.each do |item|
          if arch_metadata['metadata']['mediatype'] == 'movies'
            # get thumbnails selection
            selection = arch_metadata['files'].select { |f| f['name'].include?(item['name'].split('.').first) and f['format'] == 'Thumbnail' }.sample
            # pick one
            thumbnail = arch_server + selection['name'] unless selection.nil?
            # generate proxy
            proxies << {
                url: arch_server + item['name'],
                name: item['name'].split('.').first,
                thumbnail: thumbnail,
                type: :video,
                connector: @identifier,
                author: true,
                @identifier => {
                    arch_server: arch_server,
                    arch_item: item,
                    arch_metadata: arch_metadata['metadata'],
                    type: :video,
                    name: item['name'].split('.').first
                }
            }
          end
        end

        # return
        proxies
      end

      def initialization
        # prepare download url
        @download_url = @options[:arch_server] + @options[:arch_item]['name']

        # prepare metadata
        @metadata = []

        # parse archive.org item metadata
        @metadata << {name: 'title', value: @options[:arch_item]['title']}
        @metadata << {name: 'crc32', value: @options[:arch_item]['crc32']}
        @metadata << {name: 'sha1', value: @options[:arch_item]['sha1']}

        # parse archive.org collection metadata
        @metadata << {name: 'mediatype', value: @options[:arch_metadata]['mediatype']}
        @metadata << {name: 'collection', value: @options[:arch_metadata]['collection']}
        @metadata << {name: 'group', value: @options[:arch_metadata]['title']}
        @metadata << {name: 'description', value: @options[:arch_metadata]['description']}
        @metadata << {name: 'subject', value: @options[:arch_metadata]['subject']}
        @metadata << {name: 'identifier', value: @options[:arch_metadata]['identifier']}
        @metadata << {name: 'uploader', value: @options[:arch_metadata]['uploader']}

        # author parse
        if @options[:arch_metadata]['creator']
          @metadata << {name: 'author', value: @options[:arch_metadata]['creator']}
        else
          @metadata << {name: 'author', value: @options[:arch_metadata]['uploader']}
        end
      end

      def name
        @options[:name]
      end

      def type
        @options[:type].to_sym
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