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
        FactoryGirl.create_list(:playlist, evaluator.palylist_count, user: user)
      end
    end
  end

  factory :playlist do
    sequence :name do |n|
      "playlist_#{n}"
    end
    association :user, strategy: :build
  end

end
