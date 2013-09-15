require 'spec_helper'

describe ApiAuthenticationService do
  let(:user) { FactoryGirl.create(:user, email: "basil.siddiqui@gmail.com") }
  let(:params) do 
    {
      first_name: "Basil",
      last_name: "Siddiqui",
      email: "basil.siddiqui@gmail.com",
      id: "1069590043",
      image: "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/203021_1069590043_18138526_q.jpg",
      access_token: "CAACSWlleqMgBAOFWjZCSGBhtUduYB8j2FUwa2zXZC0lSb5rSr941f7gv4jl6pADoMp7bwykwZAZAOZC8Ax3V95BInZCbLkyqwNfXFXCLzIOO1hP45yV98WecCKriPv38voXQfiKzePRNB7Ua8BoR5BsqLKjlw2OWFWnjfylPYxKGZCC5nFh6ABbxNMZBJzMPslIZD"
    }
  end

  describe "::user_from_params" do
    it "returns the user" do
      expect( ApiAuthenticationService.user_from_params(params) ).to be_instance_of User
    end

    context 'when the user did not previously exist' do
      it "creates a user" do
        expect { ApiAuthenticationService.user_from_params(params) }.to change(User, :count).by(1)
      end

      it "create facebook authentication object" do
        expect { ApiAuthenticationService.user_from_params(params) }.to change(Authentication, :count).by(1)
      end
    end

    context 'when the user already exists' do
      before(:each) do
        user
      end

      it "returns the user based on email" do
        expect( ApiAuthenticationService.user_from_params(params) ).to eq(user)
      end
    end
  end
end
