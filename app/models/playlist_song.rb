class PlaylistSong < ActiveRecord::Base
  include IdentityCache

  has_many :votes
  cache_has_many :votes, embed: true

  belongs_to :playlist
  belongs_to :song

  validates :playlist_id, presence: true, uniqueness: { scope: :song_id }
  validates :song_id,     presence: true
  validates :vote_count,  presence: true
  validates :path,        presence: true

  def played!
    self.played_at = Time.now
    self.save
  end
end
