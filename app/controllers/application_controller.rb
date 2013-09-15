class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter  :set_csrf_cookie_for_ng

  protected

  def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def require_authentication
    redirect_to login_path unless current_user
  end

  def current_user
    @current_user ||= User.fetch_by_id user_id
  end
  helper_method :current_user

  def user_id
    params[:user_id] || session[:user_id]
  end

  def dropbox_client
    @dropbox_client ||= begin
      if current_user && dropbox_auth
        DropboxClient.new(dropbox_auth.access_token, dropbox_auth.access_token_secret)
      end
    end
  end
  helper_method :dropbox_client

  def dropbox_auth
    @dropbox_auth ||= Authentication.find_by user_id: current_user.id, provider: 'dropbox'
  end
  helper_method :dropbox_auth
end
