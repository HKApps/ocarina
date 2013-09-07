require 'spec_helper'

describe SavedSong do
  let(:saved_song) { FactoryGirl.build(:saved_song) }

  subject { saved_song }

  # Attributes
  its(:playlist_song_id) { should == subject.playlist_song_id }
  its(:user_id)          { should == subject.user_id }
  its(:name)             { should == subject.name }
  its(:deleted_at)       { should == subject.deleted_at }

  # Sanity Check
  it { should be_valid }

  # Associations
  it { should respond_to :user }
  it { should respond_to :playlist_song }

  describe "#destroy" do
    before(:each) do
      subject.save
    end

    it "does not remove the record from the db" do
      expect { subject.destroy }.to_not change{ SavedSong.count }.by(1)
    end

    it "sets the deleted_at timestamp" do
      expect(subject.deleted_at).to be_nil
      subject.destroy
      expect(subject.deleted_at).to_not be_nil
    end
  end

end
