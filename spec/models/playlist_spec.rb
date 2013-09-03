require 'spec_helper'

describe Playlist do
  let(:playlist) { Playlist.new(name: 'user', owner_id: 1) }

  subject { playlist }

  # Attributes
  it { should respond_to :name }
  it { should respond_to :owner_id }
  it { should respond_to :location }
  it { should respond_to :venue }
  it { should respond_to :start_time }
  it { should respond_to :private }
  it { should respond_to :facebook_id }
  it { should respond_to :password }

  # Associations
  it { should respond_to :user }
  it { should respond_to :host }

  # Sanity Check
  it { should be_valid }

  context 'when name is not present' do
    before(:each) do
      subject.name = nil
    end

    it { should_not be_valid }
  end

  context 'when name is not present' do
    before(:each) do
      subject.owner_id = nil
    end

    it { should_not be_valid }
  end

  describe "#host" do
    let(:playlist) { FactoryGirl.build(:playlist) }

    it "returns the user" do
      playlist.host.should == playlist.user
    end
  end

end
