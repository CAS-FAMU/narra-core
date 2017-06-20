#
# Copyright (C) 2017 CAS / FAMU
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

FactoryGirl.define do
  factory :mark_meta, class: Narra::MarkMeta do
    sequence(:input) {|n| n.to_f}
    sequence(:output) {|n| (n+1).to_f}
  end
  factory :mark_flow, class: Narra::MarkFlow do
    sequence(:input) {|n| n.to_f}
    sequence(:output) {|n| (n+1).to_f}
    sequence(:row) {|n| (n+1)}
  end
end
