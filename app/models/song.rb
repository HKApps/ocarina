class Song < ActiveRecord::Base
  has_many :playlist_songs

  belongs_to :user

  validates :path, presence: true
  validates :name, presence: true
end
