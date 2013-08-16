class SavedSong < ActiveRecord::Base
  belongs_to :user

  validates :playlist_song_id, presence: true
  validates :user_id, presence: true
  validates :name, presence: true
end
