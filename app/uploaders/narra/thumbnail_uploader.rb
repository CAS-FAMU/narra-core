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
  class ThumbnailUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    process resize_to_fill: [Narra::Tools::Settings.thumbnail_resolution.split('x')[0].to_i, Narra::Tools::Settings.thumbnail_resolution.split('x')[1].to_i]
    process convert: Narra::Tools::Settings.thumbnail_extension

    def filename
      super.chomp(File.extname(super)) + ".#{Narra::Tools::Settings.thumbnail_extension}" if original_filename.present?
    end

    def store_dir
      Narra::Storage::INSTANCE + "/items/#{model._parent._id.to_s}"
    end
  end
end