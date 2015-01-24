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

module Narra
  class Video < Item

    # Helper methods
    def video_proxy_lq
      @video_proxy_lq ||= get_file('video_proxy_lq.' + Narra::Tools::Settings.video_proxy_extension)
    end

    def video_proxy_hq
      @video_proxy_hq ||= get_file('video_proxy_hq.' + Narra::Tools::Settings.video_proxy_extension)
    end

    def audio_proxy
      @audio_proxy ||= get_file('audio_proxy.' + Narra::Tools::Settings.audio_proxy_extension)
    end

    def url_video_proxy_lq
      @url_video_proxy_lq ||= meta.where(generator: :transcoder, name: 'video_proxy_lq').collect { |meta| meta.value }.first
    end

    def url_video_proxy_hq
      @url_video_proxy_hq ||= meta.where(generator: :transcoder, name: 'video_proxy_hq').collect { |meta| meta.value }.first
    end

    def url_audio_proxy
      @url_audio_proxy ||= meta.where(generator: :transcoder, name: 'audio_proxy').collect { |meta| meta.value }.first
    end

    def prepared?
      !url_video_proxy_lq.nil? && !url_video_proxy_hq.nil? && !url_audio_proxy.nil?
    end
  end
end