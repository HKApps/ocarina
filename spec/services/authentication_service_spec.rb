require 'spec_helper'

describe AuthenticationService do
  let(:fb_omniauth)  { JSON.parse File.read('spec/fixtures/facebook_omniauth_response.json') }
  let(:db_omniauth)  { JSON.parse File.read('spec/fixtures/dropbox_omniauth_response.json') }
  let(:auth_service) { AuthenticationService.new(omniauth_response) }

  describe "#user" do
    let(:omniauth_response) { fb_omniauth }

    it "returns a user" do
      expect( AuthenticationService.new(fb_omniauth).user ).to be_instance_of(User)
    end

    context "given a returning user" do
      before(:each) { auth_service.user }

      it "finds the user" do
        expect( AuthenticationService.new(fb_omniauth).user.id ).to eq(auth_service.user.id)
      end

      it "updates the authentication object" do
        expect( AuthenticationService.new(fb_omniauth).user.authentications.count ).to eq(1)
      end

    end

    context "given a new user" do
      it "creates a user" do
        expect { AuthenticationService.new(fb_omniauth).user }.to change(User, :count).by(1)
      end

      it "creates authentication" do
        expect { AuthenticationService.new(fb_omniauth).user }.to change(Authentication, :count).by(1)
      end

      it "sends out a welcome email" do
        WelcomeMailerWorker.any_instance.should_receive(:perform)
        AuthenticationService.new(fb_omniauth).user
      end
    end

    context 'when authenticating with dropbox' do
      let(:omniauth_response) { db_omniauth }

      before(:each) do
        AuthenticationService.new(fb_omniauth).user
      end

      it "calls user_from_dropbox" do
        auth_service.should_receive(:user_from_dropbox)
        auth_service.user
      end

      it 'updates dropbox songs' do
        UpdateDropboxSongsWorker.any_instance.should_receive(:perform)
        auth_service.user
      end
    end
  end

  describe "#authenticated?" do
    it "checks if the user exists" do
      auth_service
      expect( auth_service.authenticated? ).to be_true
    end
  end

end
