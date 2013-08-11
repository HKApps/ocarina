class Playlist < ActiveRecord::Base
  include IdentityCache

  has_many :playlist_songs
  cache_has_many :playlist_songs, embed: true

  has_many :guests

  belongs_to :user, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true

  def unplayed_songs
    fetch_playlist_songs.select { |ps| !ps.played_at }
  end
end
