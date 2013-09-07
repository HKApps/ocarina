require 'factory_girl'

FactoryGirl.define do
  factory :playlist_song do
    association :playlist
    association :song
    vote_count 0
    sequence :path do |n|
      "path/#{n}"
    end
  end

end

