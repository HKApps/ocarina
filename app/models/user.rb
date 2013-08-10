class User < ActiveRecord::Base
  include IdentityCache

  has_many :authentications
  cache_has_many :authentications, embed: true

  has_many :songs
  cache_has_many :songs, embed: true

  has_many :playlists, foreign_key: :owner_id
  cache_has_many :playlists, embed: true

  has_many :guests
  cache_has_many :guests, embed: true

  validates :email, presence: true

  def playlists_as_owner
    fetch_playlists
  end

  def playlists_as_guest
    fetch_guests.map { |guest| guest.playlist }
  end

  def current_songs
    fetch_songs.select { |s| !s.removed_at }
  end

  def dropbox_authenticated?
    fetch_authentications.any? { |x| x.provider == "dropbox" }
  end

  def facebook_authenticated?
    fetch_authentications.any? { |x| x.provider == "facebook" }
  end
end
