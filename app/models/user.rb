class User < ActiveRecord::Base
  include IdentityCache
  include PgSearch

  multisearchable against: [:first_name, :last_name]

  has_many :authentications
  cache_has_many :authentications, embed: true

  has_many :songs
  cache_has_many :songs, embed: true

  has_many :playlists, foreign_key: :owner_id
  cache_has_many :playlists, embed: true

  has_many :guests
  cache_has_many :guests, embed: true

  has_many :saved_songs
  cache_has_many :saved_songs, embed: true

  validates :email, presence: true

  def playlists_as_owner
    fetch_playlists
  end

  def playlists_as_guest
    fetch_guests.map { |guest| guest.playlist }
  end

  def current_dropbox_songs
    fetch_songs.select { |s| !s.removed_at && s.provider == "dropbox" }
  end

  def current_soundcloud_songs
    fetch_songs.select { |s| !s.removed_at && s.provider == "soundcloud" }
  end

  def current_saved_songs
    fetch_saved_songs.select { |s| !s.deleted_at }
  end

  def dropbox_authenticated?
    fetch_authentications.any? { |x| x.provider == "dropbox" }
  end

  def facebook_authenticated?
    fetch_authentications.any? { |x| x.provider == "facebook" }
  end
end
