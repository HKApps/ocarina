require 'factory_girl'

FactoryGirl.define do
  factory :playlist do
    sequence :name do |n|
      "playlist_#{n}"
    end
    association :user
  end
end
