require 'factory_girl'

FactoryGirl.define do
  factory :song do
    sequence :name do |n|
      "song_#{n}"
    end
    provider "some_provider"
    path     "/path/to/song"
    user

    trait :from_dropbox do
      provider "dropbox"
      path     "/path/to/dropbox/song"
    end

    trait :from_soundcloud do
      provider "soundcloud"
      path     "/path/to/soundcloud/song"
    end
  end

end
