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

Narra::Tools::Settings.defaults[:storage_temp] = '/tmp/narra'
Narra::Tools::Settings.defaults[:storage_local_path] = '/opt/narra/storage'
Narra::Tools::Settings.defaults[:storage_local_endpoint] = 'http://narra-storage'

Narra::Tools::Settings.defaults[:thumbnail_extension] = 'png'
Narra::Tools::Settings.defaults[:thumbnail_resolution] = '350x250'
Narra::Tools::Settings.defaults[:thumbnail_count] = '5'
Narra::Tools::Settings.defaults[:thumbnail_count_preview] = '1'

Narra::Tools::Settings.defaults[:video_proxy_extension] = 'mp4'
Narra::Tools::Settings.defaults[:video_proxy_lq_resolution] = '320x180'
Narra::Tools::Settings.defaults[:video_proxy_lq_bitrate] = '300'
Narra::Tools::Settings.defaults[:video_proxy_hq_resolution] = '1280x720'
Narra::Tools::Settings.defaults[:video_proxy_hq_bitrate] = '1000'

Narra::Tools::Settings.defaults[:image_proxy_extension] = 'png'
Narra::Tools::Settings.defaults[:image_proxy_lq_resolution] = '320x180'
Narra::Tools::Settings.defaults[:image_proxy_hq_resolution] = '1280x720'

Narra::Tools::Settings.defaults[:audio_proxy_extension] = 'mp3'
Narra::Tools::Settings.defaults[:audio_proxy_bitrate] = '112'

Narra::Tools::Settings.defaults[:items_probe_interval] = 1.minute.to_s