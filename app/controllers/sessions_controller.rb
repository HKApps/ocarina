class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where(id: cookies["user_id"]).first
    auth = AuthenticationService.new(request.env['omniauth.auth'], user)
    if auth.authenticated?
      cookies.delete(:defer_dropbox_connect) if auth.provider == 'dropbox'
      session[:user_id] = auth.user.id
      redirect_to :root
    else
      render :new
    end
  end

  def defer_dropbox_connect
    cookies[:defer_dropbox_connect] = true
    head :ok
  end

  def failure
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:defer_dropbox_connect)
    redirect_to :root
  end

end
