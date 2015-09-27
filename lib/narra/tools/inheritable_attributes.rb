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
  module Tools
    module InheritableAttributes
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def inheritable_attributes(*args)
          @inheritable_attributes ||= [:inheritable_attributes]
          @inheritable_attributes += args
          args.each do |arg|
            class_eval %(
              class << self; attr_accessor :#{arg} end
             )
          end
          @inheritable_attributes
        end

        def inherited(subclass)
          @inheritable_attributes.each do |inheritable_attribute|
            instance_var = "@#{inheritable_attribute}"
            subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
          end
        end
      end
    end
  end
end