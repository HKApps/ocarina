class Guest < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  validates :user_id,     presence: true
  validates :playlist_id, presence: true

  def as_user
    User.where(id: self.user_id).first
  end
end
