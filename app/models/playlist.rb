class Playlist < ActiveRecord::Base
  has_many :playlist_songs
  has_many :guests

  belongs_to :user, class_name: 'User', foreign_key: 'owner_id'
end
