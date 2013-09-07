class SavedSong < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist_song

  validates :playlist_song_id, presence: true
  validates :user_id,          presence: true, uniqueness: { scope: :playlist_song_id }
  validates :name,             presence: true

  def destroy
    run_callbacks :destroy do
      self.deleted_at = Time.now
      save!
    end
  end

end
