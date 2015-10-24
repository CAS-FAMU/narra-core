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
    module Sequences

      # Add sequence into the NARRA
      def Core.add_sequence(project, user, options = {})
        # input check
        return if options[:sequence_name].nil? || options[:sequence_type].nil? || options[:sequence_fps].nil?

        # check for author
        author = options[:author].nil? ? user : Narra::User.find_by(username: options[:author])
        # create specific item
        sequence = Narra::Sequence.new(name: options[:sequence_name], author: author, project: project, fps: options[:sequence_fps])
        # push specific metadata
        sequence.meta << Narra::MetaSequence.new(name: 'type', value: options[:sequence_type])

        # parse metadata form the user input if exists
        if options[:metadata]
          options[:metadata].each do |meta|
            sequence.meta << Narra::MetaSequence.new(name: meta[:name], value: meta[:value], generator: :user, author: user)
          end
        end

        # save sequence
        sequence.save!

        # parse if it is not narra sequence
        if options[:sequence_type].to_sym != :narra
          process(type: :sequence, sequence: sequence._id.to_s, identifier: options[:sequence_type], params: options)
        else
          sequence.update_attributes(prepared: true)
        end
      end
    end
  end
end