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

require 'sidekiq'

module Narra
  module Workers
    class Sequence
      include Sidekiq::Worker
      include Narra::Extensions::Sequence
      include Narra::Extensions::EDL
      include Narra::Extensions::Progress

      sidekiq_options :queue => :sequences

      def perform(options)
        # input check
        return if options['project'].nil?
        # perform
        begin
          # get event
          @event = Narra::Event.find(options['event'])

          # get project
          @project = Narra::Project.find_by(name: options['project'])

          # get type
          type = options['identifier'].to_sym

          # fire event
          @event.run!

          # process
          case type
            when :edl
              # process edl
              sequence = process_edl(options['params'])
              # add new sequence
              add_sequence(sequence)
          end
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('sequence#' + options['identifier']) { e.to_s }
          # throw
          raise e
        else
          # finish progress
          set_progress(1.0)
          # log
          logger.info('sequence#' + options['identifier']) { 'Sequence successfully created.' }
          # event done
          @event.done!
        end
      end

      def project
        @project
      end

      def event
        @event
      end
    end
  end
end
