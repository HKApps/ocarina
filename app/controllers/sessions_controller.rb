class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    if @authorization
      render :text => "Welcome back! You have already signed up."
    else
      user = User.new first_name: auth_hash["info"]["first_name"], last_name: auth_hash["info"]["last_name"], email: auth_hash["info"]["email"], image: auth_hash["info"]["image"].gsub("=square", "=large")
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.save
      session[:user_id] = user.id
      render :text => "Your account has been created."
    end
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    render text: "You've logged out"
  end
end
