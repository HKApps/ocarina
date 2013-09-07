require 'factory_girl'

FactoryGirl.define do
  factory :authentication do
    provider 'dropbox'
    sequence :uid do |n|
      "provider_auth_#{n}"
    end
    association :user

    trait :dropbox do
      provider 'dropbox'
      sequence :uid do |n|
        "dropbox_#{n}"
      end
    end

    trait :facebook do
      provider 'facebook'
      sequence :uid do |n|
        "facebook_#{n}"
      end
    end

  end

end
