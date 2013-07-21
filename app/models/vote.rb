class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist_song

  validates :playlist_song_id, presence: true
  validates :user_id,          presence: true, uniqueness: { scope: :playlist_song_id }
  validates :decision,         presence: true, inclusion: { in: [1,-1] }

  class << self
    def up; Up.new; end
    def down; Down.new; end
  end

  class Up
    def action; :increment_counter; end
    def vote_num; 1; end
  end

  class Down
    def action; :decrement_counter; end
    def vote_num; -1; end
  end
end
