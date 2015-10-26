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
  module Extensions
    module Meta

      def autosave
        true
      end

      def add_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # check generator
        if options[:generator].nil? && model.kind_of?(Narra::Item)
          if self.kind_of?(Narra::SPI::Generator)
            options[:generator] = self.class.identifier
          else
            return
          end
        end
        # get meta class
        base = model.respond_to?('_type') && model._type == 'Narra::Sequence' ? model._type : model.class.superclass.to_s == 'Object' ? model.class : model.class.superclass
        # push new meta entry
        meta = "Narra::Meta#{base.to_s.split('::').last}".constantize.new(options)
        # process marks
        if options[:marks]
          # get marks
          marks = options[:marks].nil? ? [] : options.delete(:marks)
          # push marks
          marks.each do |mark|
            meta.marks << Narra::MarkMeta.new(mark)
          end
        end
        # push meta into an item
        model.meta << meta
        # save item
        model.save if autosave
        # return new meta
        meta
      end

      def update_meta(options)
        # input check
        return if options[:name].nil? || options[:value].nil?
        # retrieve meta
        meta = get_meta(name: options[:name], generator: options[:generator])
        # update value when the meta is founded
        unless meta.nil?
          meta.update_attributes(value: options[:value])
          # check for new generator field
          meta.update_attributes(generator: options[:new_generator]) unless options[:new_generator].nil?
          # check for author field
          meta.update_attributes(author: options[:author]) unless options[:author].nil?
          # update marks
          if options[:marks]
            marks = []
            # prepare marks
            options[:marks].each do |mark|
              marks << Narra::MarkMeta.new(mark)
            end
            # update
            meta.update_attributes(marks: marks)
          end
        end
        # return meta
        meta
      end

      def get_meta(options)
        # do a query
        Meta.get_meta(model, options)
      end

      def self.get_meta(model, options)
        # check for model
        return nil if model.nil?
        # do a query
        result = model.meta.where(options)
        # check and return
        result.empty? ? nil : (result.count > 1 ? result : result.first)
      end
    end
  end
end