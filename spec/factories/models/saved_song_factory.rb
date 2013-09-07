require 'factory_girl'

FactoryGirl.define do
  factory :saved_song do
    association :playlist_song
    association :user
    sequence :name do |n|
      "saved_song_#{n}"
    end
  end

end
