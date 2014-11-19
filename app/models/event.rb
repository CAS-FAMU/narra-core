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
  include Wisper::Publisher
  include AASM

  # fields
  field :message, type: String
  field :status, type: Symbol
  field :progress, type: Float, default: 0.0
  field :broadcasts, type: Array, default: []

  # item relation
  belongs_to :item, autosave: true, inverse_of: :events

  # project relation
  belongs_to :project, autosave: true, inverse_of: :events

  # callbacks
  before_destroy :broadcast_events

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

  def set_progress(number)
    update_attribute(:progress, number)
  end

  protected

  def broadcast_events
    broadcasts.each do |broadcast|
      broadcast(broadcast.to_sym, {item: (item.nil? ? nil : item._id.to_s), project: (project.nil? ? nil : project._id.to_s)})
    end
  end
end