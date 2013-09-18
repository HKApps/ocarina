require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end

    trait :with_fb_auth do
      association :authentication
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
end
