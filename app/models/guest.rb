class Guest < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  validates :user_id,     presence: true
  validates :playlist_id, presence: true
end
