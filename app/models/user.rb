class User < ActiveRecord::Base
  has_many :authentications
  has_many :songs
  has_many :parties, foreign_key: :host_id

  validates :email, presence: true
end
