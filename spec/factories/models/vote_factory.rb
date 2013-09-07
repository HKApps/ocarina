require 'factory_girl'

FactoryGirl.define do
  factory :vote do
    association :playlist_song
    association :user
    decision 0
  end
end
