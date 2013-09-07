require 'spec_helper'

describe SkipSongVote do
  let(:vote) { FactoryGirl.build(:skip_song_vote) }

  subject { vote }

  # Attributes
  its(:playlist_song_id) { should == vote.playlist_song_id }
  its(:user_id)          { should == vote.user_id }

  # Associations
  it { should respond_to :playlist_song }
  it { should respond_to :user }

end
