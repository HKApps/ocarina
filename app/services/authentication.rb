class Authentication
  def initialize(omniauth)
    @omniauth = omniauth
    @provider = @omniauth["provider"]
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

  def user_from_dropbox
    User.first_or_create do |u|
      u.first_name, u.last_name = @omniauth["info"]["name"].split(' ')
      u.email = @omniauth["info"]["email"]
    end.authorizations.first_or_create do |auth|
      auth.provider            = @provider
      auth.uid                 = @omniauth["uid"].to_s
      auth.access_token        = @omniauth["info"]["credentials"]["token"]
      auth.access_token_secret = @omniauth["info"]["credentials"]["secret"]
    end
  end

  def user_from_facebook
    User.first_or_create do |u|
      u.first_name = @omniauth["info"]["first_name"]
      u.last_name  = @omniauth["info"]["last_name"]
      u.email      = @omniauth["info"]["email"]
      u.image      = @omniauth["info"]["image"].gsub("=square", "=large")
    end.authorizations.first_or_create do |auth|
      auth.provider = @provider
      auth.uid      = @omniauth["uid"].to_s
    end
  end

end
