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
# Authors: Michal Mocnak <michal@marigan.net>, Krystof Pesek <krystof.pesek@gmail.com>
#

require 'streamio-ffmpeg'

module Narra
  module Generators
    module Modules
      # Thumbnail Generator module
      class Thumbnail < Narra::Generators::Modules::Generic

        # Set title and description fields
        @identifier = :thumbnail
        @title = 'Thumbnail'
        @description = 'Thumbnail Metadata Generator based on FFMPEG'

        def generate
          # temp path
          path = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_thumbnail_video'

          # download
          begin
            File.open(path, 'wb') do |file|
              file.write open(@item.url).read
            end
          rescue
            # Nothing to do
          end

          # prepare ffmpeg client
          video = FFMPEG::Movie.new(path)

          # process results if valid
          if video.valid?
            # create temp files
            thumb01 = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_thumbnail_01'
            thumb02 = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_thumbnail_02'
            thumb03 = Narra::Tools::Settings.storage_temp + '/' + @item._id.to_s + '_thumbnail_03'

            # create screenshots
            video.screenshot(thumb01, {seek_time: 1.0, resolution: Narra::Tools::Settings.video_thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)
            video.screenshot(thumb02, {seek_time: (video.duration / 2), resolution: Narra::Tools::Settings.video_thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)
            video.screenshot(thumb03, {seek_time: (video.duration - 1), resolution: Narra::Tools::Settings.video_thumbnail_resolution}, preserve_aspect_ratio: :height, validate: false)

            # uplad thumbnails to storages
            thumb01_storage = @item.storage.files.create(key: 'thumbnail_01.png', body: File.open(thumb01), public: true)
            thumb02_storage = @item.storage.files.create(key: 'thumbnail_02.png', body: File.open(thumb02), public: true)
            thumb03_storage = @item.storage.files.create(key: 'thumbnail_03.png', body: File.open(thumb03), public: true)

            # store meta
            add_meta(name: 'thumbnail_01', content: thumb01_storage.public_url)
            add_meta(name: 'thumbnail_02', content: thumb02_storage.public_url)
            add_meta(name: 'thumbnail_03', content: thumb03_storage.public_url)

            # clean temp
            FileUtils.rm_f(thumb01)
            FileUtils.rm_f(thumb02)
            FileUtils.rm_f(thumb03)
          end

          # clean temp
          FileUtils.rm_f(path)
        end
      end
    end
  end
end