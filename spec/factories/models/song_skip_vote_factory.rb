require 'factory_girl'

FactoryGirl.define do
  factory :skip_song_vote do
    association :playlist_song
    association :user
  end
end
