class ApiController < ApplicationController
  # TODO(mn) - Authenticate API requests
  protect_from_forgery with: :null_session

  protected

  def user
    @user ||= User.fetch_by_id params[:user_id]
  end

  def dropbox_client
    @dropbox_client ||= begin
      if user && dropbox_auth
        DropboxClient.new(dropbox_auth.access_token, dropbox_auth.access_token_secret) 
      end
    end
  end

  def dropbox_auth
    @dropbox_auth ||= Authentication.find_by user_id: user.id, provider: 'dropbox'
  end

end
