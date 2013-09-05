class Song < ActiveRecord::Base
  has_many :playlist_songs

  belongs_to :user

  validates :path,    presence: true
  validates :name,    presence: true
  validates :user_id, presence: true

  def self.find_or_initialize_from_soundcloud(sc, user_id)
    Song.where(user_id: user_id, provider: 'soundcloud', path: sc['uri']).first_or_initialize.tap do |s|
      s.name       = sc['title']
      s.properties = sc
      s.removed_at = nil
      s.changed? ? s.save! : s.touch
    end
  end

  def removed_from_dropbox!
    self.removed_at = Time.now
    self.save!
  end
end
