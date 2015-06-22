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

module Narra
  class AudioProxyUploader < CarrierWave::Uploader::Base
    include Narra::Transcoders::Media

    # set up encoder process to generate proxies
    process transcode_audio: [Narra::Tools::Settings.audio_proxy_extension.to_sym, audio_bitrate: Narra::Tools::Settings.audio_proxy_bitrate, custom: '-vn', videoinfo: true]

    def store_dir
      Narra::Storage::INSTANCE + "/items/#{model._id.to_s}"
    end
  end
end