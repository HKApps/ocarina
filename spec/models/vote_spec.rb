require 'spec_helper'

describe Vote do
  let(:vote) { FactoryGirl.build(:vote) }

  subject { vote }

  # Attributes
  its(:playlist_song_id) { should == vote.playlist_song_id }
  its(:user_id)          { should == vote.user_id }
  its(:decision)         { should == vote.decision }

  # Associations
  it { should respond_to :playlist_song }
  it { should respond_to :user }

  describe "#valid_decisions" do
    it "returns array of possible decision values" do
      expect( subject.valid_decisions ).to eq([1,0,-1])
    end
  end

  describe "#valid_decision" do
    context "when decision is legit" do
      it "returns true" do
        expect( subject.valid_decision? ).to be_true
      end
    end

    context "when decision is not legit" do
      it "returns false" do
        subject.decision = 8
        expect( subject.valid_decision? ).to be_false
      end
    end
  end

  describe "#increment_decision" do
    it "increments the decision by 1" do
      subject.increment_decision 
      expect( subject.decision ).to eq(1)
    end
  end

  describe "#decrement_decision" do
    it "decrements the decision by 1" do
      subject.decrement_decision 
      expect( subject.decision ).to eq(-1)
    end
  end

  describe "::upvote" do
    it "returns instance of Upvote" do
      expect( Vote.upvote ).to be_instance_of(Vote::Upvote)
    end
  end

  describe "::downvote" do
    it "returns instance of Downvote" do
      expect( Vote.downvote ).to be_instance_of(Vote::Downvote)
    end
  end

  describe Vote::Upvote do
    subject { Vote::Upvote.new }

    describe "#action" do
      it "returns :increment_counter" do
        expect( subject.action ).to eq(:increment_counter)
      end
    end

    describe "#vote_method" do
      it "returns :increment_decision" do
        expect( subject.vote_method ).to eq(:increment_decision)
      end
    end
  end

  describe Vote::Downvote do
    subject { Vote::Downvote.new }

    describe "#action" do
      it "returns :decrement_counter" do
        expect( subject.action ).to eq(:decrement_counter)
      end
    end

    describe "#vote_method" do
      it "returns :decrement_decision" do
        expect( subject.vote_method ).to eq(:decrement_decision)
      end
    end
  end

end
