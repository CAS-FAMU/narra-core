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
require 'streamio-ffmpeg'
require 'open-uri'

module Narra
  module Workers
    class Transcoder
      include Sidekiq::Worker
      include Narra::Extensions::Progress

      sidekiq_options :queue => :transcodes

      def perform(options)
        # check
        return if options['item'].nil? || options['identifier'].nil? || options['event'].nil?

        # get event
        @event = Narra::Event.find(options['event'])

        # get item
        item = Narra::Item.find(options['item'])

        # fire event
        @event.run!

        # transcode
        begin
          # temp path
          temporary = Narra::Tools::Settings.storage_temp + '/' + item._id.to_s + '_raw'
          # download
          File.open(temporary, 'wb') do |file|
            file.write open(options['identifier']).read
          end

          # get ffmpeg object
          raw = FFMPEG::Movie.new(temporary)

          # process results if valid
          if raw.valid?
            # transcoders to run over
            transcoders = []

            # parse url for proper connector
            Narra::Core.transcoders.each do |transcoder|
              if transcoder.valid?(item)
                transcoders << transcoder.new(item, @event, raw)
              end
            end

            # calculate progress
            progress = 0.0

            # start transcoding process
            transcoders.each do |transcoder|
              transcoder.transcode(progress, progress += 1.0 / transcoders.count)
            end

            # finish progress
            set_progress(1.0)
          end

          # clean temp file provided by connector
          FileUtils.rm_f(temporary)
        rescue => e
          # nothing to do
          # TODO logging system
          puts e.backtrace
        end
        # event done
        @event.done!
      end

      def event
        @event
      end
    end
  end
end