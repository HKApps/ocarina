class Song < ActiveRecord::Base
  has_many :playlist_songs

  belongs_to :user

  validates :path, presence: true
  validates :name, presence: true

  def removed_from_dropbox!
    self.removed_at = Time.now
    self.save!
  end
end
