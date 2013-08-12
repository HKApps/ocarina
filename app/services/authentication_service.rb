class AuthenticationService
  attr_reader :provider

  def initialize(omniauth, current_user = nil)
    @omniauth     = omniauth
    @current_user = current_user
    @provider     = @omniauth["provider"]
  end

  def user
    @user ||= user_from_omniauth(@provider)
  end

  def authenticated?
    user.present?
  end

  private

  def user_from_omniauth(provider)
    case @provider
    when "facebook" then user_from_facebook
    when "dropbox"  then user_from_dropbox
    end
  end

  def user_from_facebook
    (@current_consumer || find_user_by_omniauth_email).first_or_initialize.tap do |user|
      user.email      = @omniauth["info"]["email"]
      user.first_name = @omniauth["info"]["first_name"]
      user.last_name  = @omniauth["info"]["last_name"]
      user.image      = @omniauth["info"]["image"].gsub("=square", "=large")
      user.save!

      user.authentications.where(
        provider: @provider,
        uid:      @omniauth["uid"].to_s
      ).first_or_create

      update_dropbox_songs(user.id) if user.authentications.any? { |auth| auth.provider == "dropbox" }
    end
  end

  # Users must authenticate with FB before authenticating with DB.
  def user_from_dropbox
    return unless @current_user
    @current_user.tap do |user|
      auth = user.authentications.where(provider: @provider, uid: @omniauth["uid"].to_s).first_or_initialize
      auth.access_token        = @omniauth["credentials"]["token"]
      auth.access_token_secret = @omniauth["credentials"]["secret"]
      auth.save!

      update_dropbox_songs(user.id)
    end
  end

  def find_user_by_omniauth_email
    User.where email: @omniauth["info"]["email"]
  end

  def update_dropbox_songs(user_id)
    UpdateDropboxSongsWorker.new.async.perform(user_id)
  end

end
