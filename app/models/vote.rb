class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist_song

  validates :playlist_song_id, presence: true
  validates :user_id,          presence: true, uniqueness: { scope: :playlist_song_id }
  validates :decision,         presence: true, inclusion: { in: lambda { |vote| vote.valid_decisions } }

  after_initialize :set_default_values

  def valid_decision?
    valid_decisions.include? self.decision
  end

  def valid_decisions
    [1,0,-1]
  end

  def increment_decision
    self.decision += 1
  end

  def decrement_decision
    self.decision += -1
  end

  class << self
    def up; Up.new; end
    def down; Down.new; end
  end

  class Up
    def action;      :increment_counter; end
    def vote_method; :increment_decision; end
  end

  class Down
    def action;      :decrement_counter; end
    def vote_method; :decrement_decision; end
  end

  private

  def set_default_values
    self.decision ||= 0
  end
end
