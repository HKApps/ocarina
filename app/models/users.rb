class Users < ActiveRecord::Base
  has_many :authorizations
  validates :name, :email, presence: true
end
