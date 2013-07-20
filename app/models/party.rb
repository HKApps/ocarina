class Party < ActiveRecord::Base
  has_many :playlists

  belongs_to :user, class_name: 'User', foreign_key: 'host_id'

  validates :name, presence: true
end
