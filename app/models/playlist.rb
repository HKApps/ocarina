class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :guests

  belongs_to :user, class_name: 'User', foreign_key: 'owner_id'

  def unplayed_songs
    playlist_songs.select { |ps| !ps.played_at }
  end
end
