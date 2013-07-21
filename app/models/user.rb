class User < ActiveRecord::Base
  has_many :authentications
  has_many :songs
  has_many :playlists, foreign_key: :owner_id

  validates :email, presence: true

  def status
    self.attributes.merge({
      dropbox_authenticated:  dropbox_authenticated?,
      facebook_authenticated: facebook_authenticated?,
      dropbox_songs:          songs,
      playlists:              playlists
    }).to_json
  end

  def dropbox_authenticated?
    !!Authentication.find_by(user_id: self.id, provider: "dropbox")
  end

  def facebook_authenticated?
    !!Authentication.find_by(user_id: self.id, provider: "facebook")
  end
end
