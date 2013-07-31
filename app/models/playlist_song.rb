class PlaylistSong < ActiveRecord::Base
  has_many :votes

  belongs_to :playlist
  belongs_to :song

  def played!
    self.played_at = Time.now
    self.save
  end
end
