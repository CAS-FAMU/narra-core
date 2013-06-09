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

class Meta
  include Mongoid::Document
  include Mongoid::Timestamps

  field :contributor, type: String
  field :coverage, type: String
  field :creator, type: String
  field :date, type: String
  field :description, type: String
  field :format, type: String
  field :identifier, type: String
  field :language, type: String
  field :publisher, type: String
  field :relation, type: String
  field :rights, type: String
  field :source, type: String
  field :subject, type: String
  field :title, type: String
  field :type, type: String


  #validates :title, presence: true
  #validates :coverage, presence: true
  #validates :creator, presence: true
  #validates :date, presence: true
  #validates :description, presence: true
  #validates :format, presence: true
  #validates :identifier, presence: true
  #validates :language, presence: true
  #validates :publisher, presence: true
  #validates :relation, presence: true
  #validates :rights, presence: true
  #validates :source, presence: true
  #validates :subject, presence: true
  #validates :title, presence: true
  #validates :type, presence: true


end