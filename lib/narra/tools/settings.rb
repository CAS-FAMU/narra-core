#
# Copyright (C) 2013 CAS / FAMU
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

module Narra
  module Tools
    class Settings

      # settings prefix
      PREFIX = 'settings_'

      # default values
      cattr_accessor :defaults

      self.defaults = Narra::Tools::DefaultsHash.new

      # read cache to eliminate acces to the db
      cattr_accessor :cache
      self.cache = ActiveSupport::Cache::NullStore.new

      # options passed to cache.fetch() and cache.write(). example: {:expires_in => 5.minutes}
      cattr_accessor :cache_options
      self.cache_options = {}

      def self.get(name)
        _get_value(name)
      end

      def self.set(name, value)
        _set_value(name, value)
      end

      def self.all()
        # empty arrya
        results = []
        # iterate and remove prefix
        Narra::Cache.where(name: /#{PREFIX}/i).each do |item|
          results << {name: item.name.gsub(/#{PREFIX}/, ''), value: item.data['value']}
        end

        #
        return results
      end

      #get or set a variable with the variable as the called method
      def self.method_missing(method, *args)
        if self.respond_to?(method)
          super
        else
          # get method name
          method_name = method.to_s
          #set a value for a variable
          if method_name =~ /=$/
            # get property name
            name = method_name.gsub('=', '')
            # get value to be set
            value = args.first
            # set value
            _set_value(name, value)
          else
            # retrieve value
            _get_value(method_name)
          end
        end
      end

      private
      def self._get_value(name)
        # add prefix
        prefixed = PREFIX + name
        # get from cache
        cached = cache.read(prefixed)
        # check for cache
        if cached.nil?
          # receive value
          item = Narra::Cache.find_by(name: prefixed)
          # check for existence
          if item.nil?
            defaults[name]
          else
            # get value
            value = item.data['value']
            # store in cache
            cache.write(prefixed, value)
            # return
            return value
          end
        else
          cached
        end
      end

      def self._set_value(name, value)
        # add prefix
        prefixed = PREFIX + name
        # receive scope content in case it exists otherwise create a new entry
        item = Narra::Cache.find_or_create_by(name: prefixed)
        # check if the value is same or not
        if item.data['value'] != value
          # modify hash
          if value.nil? then
            # if the value is null destroy whole entry
            item.destroy!
            # clear cache
            cache.delete(prefixed)
          else
            # set data
            item.data = {'value' => value}
            # write cache
            cache.write(prefixed, value)
            # persist object
            item.save
          end
        end
      end
    end
  end
end