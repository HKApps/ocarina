require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end

    factory :user_with_playlists do
      ignore do
        playlist_count 5
      end

      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:playlist, evaluator.playlist_count, user: user)
      end
    end

    factory :user_with_sc_songs do
      ignore do
        song_count 5
      end

      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:song, evaluator.song_count, user: user)
      end
    end
  end

  factory :playlist do
    sequence :name do |n|
      "playlist_#{n}"
    end
    association :user, strategy: :build
  end

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
