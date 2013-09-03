require 'spec_helper'

describe User do
  let(:user) { User.new(email: 'user@example.com') }

  subject { user }

  it { should respond_to :email }
  it { should respond_to :first_name }
  it { should respond_to :last_name }
  it { should respond_to :image }
  it { should be_valid }

  context "when email is not present" do
    before(:each) do
      user.email = nil
    end

    it { should_not be_valid }
  end

end
