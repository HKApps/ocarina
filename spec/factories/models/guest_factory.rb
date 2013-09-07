require 'factory_girl'

FactoryGirl.define do
  factory :guest do
    association :user
    association :playlist
  end
end
