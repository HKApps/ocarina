require 'spec_helper'

describe PlaylistSong do
  let(:playlist_song) { FactoryGirl.build(:playlist_song) }

  subject { playlist_song }

  # Attributes
  it { should respond_to :playlist_id }
  it { should respond_to :song_id }
  it { should respond_to :vote_count }
  it { should respond_to :path }
  it { should respond_to :media_url }
  it { should respond_to :song_name }
  it { should respond_to :played_at }
  it { should respond_to :provider }
  it { should respond_to :skip_song_vote_count }

  # Associations
  it { should respond_to :song }
  it { should respond_to :playlist }

  # Sanity Check
  it { should be_valid }

  context 'when playlist_id is not present' do
    before(:each) do
      subject.playlist_id = nil
    end

    it { should_not be_valid }
  end

  context 'when song_id is not present' do
    before(:each) do
      subject.song_id = nil
    end

    it { should_not be_valid }
  end

  context 'when vote_count is not present' do
    before(:each) do
      subject.vote_count = nil
    end

    it { should_not be_valid }
  end

  describe "#played!" do
    it "sets the played_at field with the current time" do
      subject.played!
      expect( subject.played_at ).to_not be_nil
    end
  end
end
