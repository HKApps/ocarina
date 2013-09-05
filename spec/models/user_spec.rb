require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  # Attributes
  it { should respond_to :email }
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :image }

  # Associations
  it { should respond_to :playlists }
  it { should respond_to :songs }

  # Sanity Check
  it { should be_valid }

  context "when email is not present" do
    before(:each) do
      user.email = nil
    end

    it { should_not be_valid }
  end

  describe "#current_soundcloud_songs" do
    let(:song) { FactoryGirl.create(:song, :from_soundcloud, user: user) }

    before(:each) { song }

    it "returns the user's soundcloud songs" do
      expect( subject.current_soundcloud_songs ).to include(song)
    end
  end

  describe "#current_dropbox_songs" do
    let(:song) { FactoryGirl.create(:song, :from_dropbox, user: user) }

    before(:each) { song }

    it "returns list of the user's dropbox songs" do
      expect( subject.current_dropbox_songs ).to include(song)
    end

    context 'when the song has been removed from dropbox' do
      it 'does not show up in list' do
        song.removed_from_dropbox!
        expect( subject.current_dropbox_songs ).to be_empty
      end
    end
  end

end
