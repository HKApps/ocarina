class Playlist < ActiveRecord::Base
  belongs_to :song

  belongs_to :party

  validate :party_id, presence: true
  validate :song_id, presence: true
end
