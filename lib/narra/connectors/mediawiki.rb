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
require 'mediawiki_api'

module Narra
  module Connectors
    class Mediawiki < Narra::SPI::Connector

      # Set title and description fields
      @identifier = :mediawiki
      @title = 'Mediawiki Connector'
      @description = 'Mediawiki Connector uses Mediawiki API'
      @priority = 999

      def self.valid?(url)
        # check for protocol
        return false if url.start_with?('http')
        # parse url
        begin
          uri = URI.parse(url)
          # create client
          client = MediawikiApi::Client.new("#{uri.scheme}://#{uri.host}/w/api.php")
          # api request
          client.meta :siteinfo
        rescue
          # it is not a mediawiki link
          return false
        else
          # it is a mediawiki link
          return true
        end
      end

      def self.resolve(url)
        # parse url
        uri = URI.parse(url)

        # check if it is a category
        if File.readlines(open(url)).grep(/\"wgCanonicalNamespace\":\"Category\"/).size > 0
          category = CGI.unescape(File.basename(uri.path).split(':').last)
        end

        # create mediawiki client
        client = MediawikiApi::Client.new("#{uri.scheme}://#{uri.host}/w/api.php")

        # parse category or single page
        if category
          # proxies container
          proxies = []

          # get all articles
          articles = client.action :query, list: "categorymembers", cmtitle: "Category:#{category}", cmlimit: 500, token_type: false

          # parse articles
          articles.data["categorymembers"].each do |article|
            # perpare proxy
            proxies << prepare_proxy(uri, article)
          end

          # return proxies
          proxies
        else
          # article title
          title = CGI.unescape(File.basename(url))
          # get article
          article = (client.action :query, titles: title, token_type: false).data["pages"].values.first
          # preturn proxy
          [prepare_proxy(uri, article)]
        end
      end

      def initialization
        # parse url
        uri = URI.parse(@url)

        # create mediawiki client
        client = MediawikiApi::Client.new("#{uri.scheme}://#{uri.host}/w/api.php")

        # download content
        @content = open("#{@url}?action=raw").read

        # prepare metadata
        @metadata = []

        # store main text value
        @metadata << {name: 'text', value: @content}

        # parse article related metadata
        chunks = @content.split('|')

        # pass through the chunks to find metadata
        chunks.each do |chunk|
          if !chunk.start_with?('{') && chunk.include?('=')
            # get values
            values = chunk.split('=')
            # parse
            if values.size > 1
              # parse name
              name = prepare_string(values[0].downcase.strip)
              value = values[1].split("\n")[0]
              # store non empty and non template value
              if !value.nil? && validate_string(name)
                # strip value
                value_stripped = prepare_string(value.strip)
                # check and add
                if !value_stripped.empty? && validate_string(value_stripped)
                  @metadata << {name: name, value: value_stripped}
                end
              end
            end
          end
        end

        # parse author
        if @metadata.select { |m| m[:name] == 'author' }.empty?
          # get contributors
          contributors = client.action :query, titles: @options[:name], prop: "contributors", token_type: false
          # parse
          @metadata << {name: 'author', value: contributors.data["pages"].values.first["contributors"].first["name"]}
        end
      end

      def name
        @options[:name]
      end

      def type
        :text
      end

      def metadata
        @metadata
      end

      def download_url
        @url
      end

      private

      def self.prepare_proxy(uri, article)
        # parse url and name
        name = CGI.unescape(article["title"])
        title = CGI.escape(name.gsub(' ', '_'))
        match = uri.path.match(/(.*)\//)
        article_url = "#{uri.scheme}://" + "#{uri.host}/#{match.nil? ? uri.path : match.captures.first}/#{title}".gsub("//", "/")

        # return proxy
        {
            url: article_url,
            name: name,
            thumbnail: nil,
            type: :text,
            author: true,
            connector: @identifier,
            @identifier => {
                name: name
            }
        }
      end

      def prepare_string(string)
        # check for leading brackets
        match = string.match(/[\[|\{|\"]+(.*?)[\]|\}|\"]+/)
        # get value
        match.nil? ? string : match.captures.first
      end

      def validate_string(string)
        string.match(/([\[|\]|\{|\}|\<|\>])+/).nil?
      end
    end
  end
end