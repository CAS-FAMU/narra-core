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

require 'factory_girl_rails'

FactoryGirl.define do
  factory :cache, class: Narra::Cache do
    name "test"
  end
  factory :event, class: Narra::Event do
    sequence(:message) { |n| "test_event_#{n}" }
  end
  factory :identity, class: Narra::Identity do
    provider "test"
    uid "tester@narra.eu"
  end
  factory :item, class: Narra::Item do
    sequence(:name) { |n| "test_item_#{n}" }
    sequence(:url) { |n| "url://test_item_url_#{n}" }
  end
  factory :item_prepared do
    sequence(:name) { |n| "test_item_prepared_#{n}" }
    sequence(:url) { |n| "url://test_item_prepared_url_#{n}" }
  end
  factory :junction, class: Narra::Junction do
    sequence(:weight) { 1.00 }

    trait :generic do
      sequence(:synthesizer) { :generic }
    end
  end
  factory :library, class: Narra::Library do
    sequence(:name) { |n| "test_library_#{n}" }
    sequence(:description) { |n| "Description for the Test Library #{n}" }
  end
  factory :meta_item, class: Narra::MetaItem do
    sequence(:name) { |n| "test_meta_#{n}" }
    sequence(:value) { |n| "Test Meta Value #{n}" }

    trait :source do
      sequence(:generator) { :source }
    end

    trait :generated do
      sequence(:generator) { :generated }
    end
  end
  factory :meta_library, class: Narra::MetaLibrary do
    sequence(:name) { |n| "test_meta_#{n}" }
    sequence(:value) { |n| "Test Meta Value #{n}" }
  end
  factory :meta_project, class: Narra::MetaProject do
    sequence(:name) { |n| "test_meta_#{n}" }
    sequence(:value) { |n| "Test Meta Value #{n}" }
  end
  factory :project, class: Narra::Project do
    sequence(:name) { |n| "test_project_#{n}" }
    sequence(:title) { |n| "Test Project #{n}" }
    sequence(:description) { |n| "Description for the Test Project #{n}" }
  end
  factory :sequence, class: Narra::Sequence do
    sequence(:name) { |n| "test_sequence_#{n}" }
  end
  factory :mark_meta, class: Narra::MarkMeta do
    sequence(:in) { |n| n.to_f }
    sequence(:out) { |n| (n+1).to_f }
  end
  factory :user, class: Narra::User do
    sequence(:name) { |n| "tester#{n}" }
    sequence(:username) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@narra.eu" }
  end
end