class AuthenticationService
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
    end
  end

  # Users must authenticate with FB before authenticating with DB.
  def user_from_dropbox
    return unless @current_user
    @current_user.tap do |user|
      user.authentications.where(provider: @provider, uid: @omniauth["uid"].to_s).first_or_create do |auth|
        auth.access_token        = @omniauth["credentials"]["token"]
        auth.access_token_secret = @omniauth["credentials"]["secret"]
      end
    end
  end

  def find_user_by_omniauth_email
    User.where email: @omniauth["info"]["email"]
  end

end
