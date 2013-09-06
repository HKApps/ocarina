require 'spec_helper'

describe Song do
  let(:song) { FactoryGirl.create(:song) }

  subject { song }

  # Attributes
  it { should respond_to :name }
  it { should respond_to :provider }
  it { should respond_to :path }
  it { should respond_to :user_id }
  it { should respond_to :properties }
  it { should respond_to :removed_at }

  # Associations
  it { should respond_to :user }

  # Sanity Check
  it { should be_valid }

  context 'when name is not present' do
    before(:each) do
      subject.name = nil
    end

    it { should_not be_valid }
  end

  context 'when path is not present' do
    before(:each) do
      subject.path = nil
    end

    it { should_not be_valid }
  end

  context 'when user_id is not present' do
    before(:each) do
      subject.user_id = nil
    end

    it { should_not be_valid }
  end

  describe ".find_or_initialize_from_soundcloud" do
    let(:soundcloud_response) { File.read("spec/fixtures/soundcloud_response.json") }
    let(:user)                { FactoryGirl.create(:user) }
    let(:song)                { Song.find_or_initialize_from_soundcloud(soundcloud_response, user.id) }

    context "when the song does not exist" do
      it "creates the object" do
        expect { song }.to  change(Song, :count).by(1)
      end

      it "sets the provider to soundcloud" do
        song.provider.should == 'soundcloud'
      end
    end

    context "when the song exists" do
      let(:another_song)  { Song.find_or_initialize_from_soundcloud(soundcloud_response, user.id) }

      before(:each) do
        song
      end

      it "returns the same song" do
        another_song.id.should == song.id
      end

      it "updates the updated_at timestamp" do
        another_song.created_at.should     == song.created_at
        another_song.updated_at.should_not == song.updated_at
      end

      it "sets removed_at to nil" do
        song.removed_at = Time.now
        song.save!
        another_song.removed_at.should be_nil
      end
    end
  end

  describe "#removed_from_dropbox" do
    it "sets the removed_at attribute" do
      song.removed_from_dropbox!
      song.removed_at.should_not be_nil
    end
  end

end
