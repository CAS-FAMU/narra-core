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

class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  # fields
  field :message, type: String
  field :progress, type: Float
  field :status, type: Symbol

  # item relation
  belongs_to :item, class_name: 'Item', autosave: true, inverse_of: :events

  # project relation
  belongs_to :project, class_name: 'Item', autosave: true, inverse_of: :events

  aasm :column => :status, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :running
    state :done

    event :run do
      transitions :to => :running, :from => [:pending]
    end

    event :done, after: Proc.new { self.destroy } do
      transitions :to => :done, :from => [:running]
    end
  end
end