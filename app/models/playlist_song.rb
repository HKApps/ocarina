class PlaylistSong < ActiveRecord::Base
  include IdentityCache

  has_many :votes
  cache_has_many :votes, embed: true

  belongs_to :playlist
  belongs_to :song

  def played!
    self.played_at = Time.now
    self.save
  end
end
