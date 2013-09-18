require 'factory_girl'

FactoryGirl.define do
  factory :authentication do
    provider 'facebook'
    uid '123'
    access_token 'whater'
    access_token_secret 'yeah'
  end
end
