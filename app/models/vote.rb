class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist_song

  validates :playlist_song_id, presence: true
  validates :user_id,          presence: true, uniqueness: { scope: :playlist_song_id }
  validates :decision,         presence: true, inclusion: { in: [1,-1] }
end
