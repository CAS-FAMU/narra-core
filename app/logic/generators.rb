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

module Generators

  # Process invoker
  def self.process(item, generators = nil)
    # if there is no generator specified pass through all active
    generators ||= all_identifiers
    # select them
    generators.select! {|generator| all_identifiers.include?(generator.to_sym)}
    # perform generator process
    generators.each do |generator|
      Generators::Worker.perform_async(item._id.to_s, generator)
    end
    # return resume of the action
    { item: {id: item._id, name: item.name}, generators: generators }
  end

  # Return all active generators
  def self.all
    @generators ||= Generators::Modules.constants.collect { |c| Generators::Modules.const_get(c) }.
        select { |c| c.is_a?(Class) && c.name != 'Generators::Modules::Generic' && c.ancestors.include?(Generators::Modules::Generic) }
  end

  # Return all active generators
  def self.all_identifiers
    @identifiers ||= all.collect { |generator| generator.identifier }
  end
end