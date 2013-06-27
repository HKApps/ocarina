class User < ActiveRecord::Base
  has_many :authentications
  has_many :songs

  validates :email, presence: true
end
