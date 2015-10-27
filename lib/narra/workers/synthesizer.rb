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

require 'sidekiq'

module Narra
  module Workers
    class Synthesizer
      include Sidekiq::Worker
      include Narra::Extensions::Progress

      sidekiq_options :queue => :synthesizers

      def perform(options)
        # check
        return if options['project'].nil? || options['identifier'].nil? || options['event'].nil?
        # perform
        begin
          # get event
          @event = Narra::Event.find(options['event'])

          # get project
          project = Narra::Project.find(options['project'])

          # fire event
          @event.run!

          # get generator
          synthesizer = Narra::Core.synthesizers.detect { |s| s.identifier == options['identifier'].to_sym }

          # perform generate if generator is available
          synthesizer.new(project, @event).synthesize(options['options']) unless project.nil?
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('synthesizer#' + options['identifier']) { e.to_s }
          # throw
          raise e
        else
          # finish progress
          set_progress(1.0)
          # log
          logger.info('synthesizer#' + options['identifier']) { 'Project ' + project.name + '#' + options['project'] + ' successfully synthesized.' }
          # event done
          @event.done!
        end
      end

      def event
        @event
      end
    end
  end
end