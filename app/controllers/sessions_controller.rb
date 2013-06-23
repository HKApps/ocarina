class SessionsController < ApplicationController
  def new
  end

  def create
    auth = AuthenticationService.new(request.env['omniauth.auth'], current_user)
    if auth.authenticated?
      session[:user_id] = auth.user.id
      render :text => "Logged in!"
    else
      render :text => "Something went wrong..."
    end
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    render text: "You've logged out"
  end
end
