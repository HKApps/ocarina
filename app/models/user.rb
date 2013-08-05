class User < ActiveRecord::Base
  has_many :authentications
  has_many :songs
  has_many :playlists, foreign_key: :owner_id
  has_many :guests

  validates :email, presence: true

  def playlists_as_guest
    guests.map { |guest| guest.playlist }
  end

  def current_songs
    songs.select { |s| !s.removed_at }
  end

  def dropbox_authenticated?
    authentications.any? { |x| x.provider == "dropbox" }
  end

  def facebook_authenticated?
    authentications.any? { |x| x.provider == "facebook" }
  end
end
