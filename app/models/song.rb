class Song < ActiveRecord::Base
  belongs_to :user

  validates :path, presence: true
  validates :name, presence: true
end
