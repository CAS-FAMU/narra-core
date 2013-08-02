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
  module Synthesizers
    class Worker
      include Sidekiq::Worker
      sidekiq_options :queue => :synthesizers

      def perform(options)
        return if options['item'].nil? || options['project'].nil? || options['identifier'].nil?
        # get generator
        synthesizer = Narra::Core.synthesizers.detect { |s| s.identifier == options['identifier'].to_sym }
        # perform generate if generator is available
        synthesizer.new(Item.find(options['item']), Project.find(options['project'])).synthesize
      end
    end
  end
end