require 'spec_helper'

describe Authentication do
  let(:authentication) { FactoryGirl.build(:authentication) }

  subject { authentication }

  # Attributes
  its(:provider)            { should == subject.provider }
  its(:uid)                 { should == subject.uid }
  its(:user_id)             { should == subject.user_id }
  its(:access_token)        { should == subject.access_token }
  its(:access_token_secret) { should == subject.access_token_secret }

  # Associations
  it { should respond_to :user }

  # Sanity Check
  it { should be_valid}

  context "when provider is not present" do
    before(:each) do
      subject.provider = nil
    end

    it { should_not be_valid }
  end

  context "when provider is not one of facebook or dropbox" do
    before(:each) do
      subject.provider = 'wrong'
    end

    it { should_not be_valid }
  end

  context "when uid is not present" do
    before(:each) do
      subject.uid = nil
    end

    it { should_not be_valid }
  end

  context "when user_id is not present" do
    before(:each) do
      subject.user_id = nil
    end

    it { should_not be_valid }
  end
end
