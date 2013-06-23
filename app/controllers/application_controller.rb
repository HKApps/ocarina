class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def dropbox_client
    @dropbox_client ||= DropboxClient.new(dropbox_auth.access_token, dropbox_auth.access_token_secret) if current_user
  end

  def dropbox_auth
    @dropbox_auth ||= Authorization.find_by id: current_user.id, provider: 'dropbox'
  end
end
