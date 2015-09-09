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
    class Purge
      include Sidekiq::Worker

      sidekiq_options :queue => :purge

      def perform(options)
        # check
        return if options['identifier'].nil? || options['event'].nil?
        # perform
        begin
          # get event
          @event = Narra::Event.find(options['event'])

          # get identifier
          identifier = options['identifier'].to_sym

          case identifier
            when :library
              # get library
              library = Narra::Library.find(options['library'])
              # log object
              @object = "#{library._id.to_s}|#{library.name}"
              # fire event
              @event.run!
              # destroy library
              library.destroy
          end
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('purge#' + options['identifier'] + '#' + @object) { e.to_s }
          # throw
          raise e
        else
          # log
          logger.info('purge#' + options['identifier']) { options['identifier'].capitalize + " " + @object + ' successfully purged.' }
          # event done
          @event.done!
        end
      end
    end
  end
end