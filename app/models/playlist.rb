class Playlist < ActiveRecord::Base
  include IdentityCache

  has_many :playlist_songs
  cache_has_many :playlist_songs, embed: true

  has_many :guests

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  alias_method :host, :owner

  validates :name,     presence: true
  validates :owner_id, presence: true

  def guests_as_users
    self.guests.map(&:user)
  end

  def unplayed_songs
    fetch_playlist_songs.select { |ps| !ps.played_at }
  end

  def played_songs
    fetch_playlist_songs.select { |ps| ps.played_at }
  end
end
