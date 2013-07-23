class SessionsController < ApplicationController
  def new
  end

  def create
    auth = AuthenticationService.new(request.env['omniauth.auth'], current_user)
    if auth.authenticated?
      session[:user_id] = auth.user.id
      UpdateDropboxSongsWorker.perform_async(auth.user.id)
      redirect_to :root
    else
      render :new
    end
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
