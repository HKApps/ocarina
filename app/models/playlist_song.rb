class PlaylistSong < ActiveRecord::Base
  has_many :votes

  belongs_to :playlist
  belongs_to :song
end
