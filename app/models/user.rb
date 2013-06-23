class User < ActiveRecord::Base
  has_many :authorizations
  validates :first_name, :last_name, :email, presence: true
end
