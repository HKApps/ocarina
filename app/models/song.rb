class Song < ActiveRecord::Base
  has_many :playlists

  belongs_to :user

  validates :path, presence: true
  validates :name, presence: true
end
