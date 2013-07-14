class Playlist < ActiveRecord::Base
  has_many :songs

  belongs_to :parties

  validate :party_id, presence: true
  validate :song_id, presence: true
end
