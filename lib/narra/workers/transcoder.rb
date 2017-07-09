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
require 'wisper'

module Narra
  module Workers
    class Transcoder
      include Sidekiq::Worker
      include Narra::Extensions::Progress

      sidekiq_options :queue => :transcodes

      def perform(options)
        # check
        return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?
        # transcode
        begin
          # get event
          @event = Narra::Event.find(options['event'])

          # get item
          item = Narra::Item.find(options['item'])

          # fire event
          @event.run!

          # create listener
          listener = Narra::Listeners::Transcoder.new
          # push event
          listener.event = @event

          # Temporary subscribe listener
          Wisper.subscribe(listener) do
            # process transcoder
            item.send("remote_#{item.type}_url=".to_sym, options['identifier'])
          end

          # save item
          item.save!

          # finish progress
          set_progress(1.0)
        rescue => e
          # reset event
          @event.reset!
          # log
          logger.error('transcoder#' + options['identifier']) {e.message}
          logger.error('transcoder#' + options['identifier']) {e.backtrace.join("\n")}
          # throw
          raise e
        else
          # log
          logger.info('transcoder#' + options['identifier']) { 'Item ' + item.name + '#' + options['item'] + ' successfully transcoded.' }
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