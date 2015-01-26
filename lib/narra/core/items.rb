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

module Narra
  module Core
    module Items

      # Add item into the NARRA
      def Core.add_item(url, author, user, library, metadata = [])
        # input check
        return if url.nil? || author.nil? || user.nil? || library.nil?

        # connector container
        connector = nil

        # parse url for proper connector
        connectors.each do |conn|
          if conn.valid?(url)
            connector = conn.new(url)
            # break the loop
            break
          end
        end

        # check
        return nil if connector.nil?

        # item container
        item = nil

        # recognize type
        case connector.type
          when :video
            # create specific item
            item = Narra::Video.new(name: connector.name, url: url, library: library)
            # push specific metadata
            item.meta << Narra::MetaItem.new(name: 'type', value: :video, generator: :source)
          when :image
            # create specific item
            item = Narra::Image.new(name: connector.name, url: url, library: library)
            # push specific metadata
            item.meta << Narra::MetaItem.new(name: 'type', value: :image, generator: :source)
          when :audio
            # create specific item
            item = Narra::Audio.new(name: connector.name, url: url, library: library)
            # push specific metadata
            item.meta << Narra::MetaItem.new(name: 'type', value: :audio, generator: :source)
        end

        # create source metadata from essential fields
        item.meta << Narra::MetaItem.new(name: 'name', value: connector.name, generator: :source)
        item.meta << Narra::MetaItem.new(name: 'url', value: url, generator: :source)
        item.meta << Narra::MetaItem.new(name: 'library', value: library.name, generator: :source)
        item.meta << Narra::MetaItem.new(name: 'author', value: author, generator: :source)

        # parse metadata from connector if exists
        connector.metadata.each do |meta|
          item.meta << Narra::MetaItem.new(name: meta[:name], value: meta[:value], generator: :source)
        end

        # parse metadata form the user input if exists
        metadata.each do |meta|
          item.meta << Narra::MetaItem.new(name: meta[:name], value: meta[:value], generator: user.username.to_sym)
        end

        # save item
        item.save!

        # start transcode process
        process(type: :transcoder, item: item._id.to_s, identifier: connector.download_url)

        # return item
        return item
      end
    end
  end
end