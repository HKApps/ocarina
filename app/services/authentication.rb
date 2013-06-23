class Authentication
  def initialize(omniauth, user = nil)
    @omniauth = omniauth
    @user     = user
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
    first_name, last_name = @omniauth["info"]["name"].split(' ')
    user = User.where(
      id:         user.try(:id),
      first_name: first_name,
      last_name:  last_name,
      email:      @omniauth["info"]["email"]
    ).first_or_create

    user.authorizations.where(
      provider:            @provider,
      uid:                 @omniauth["uid"].to_s,
      access_token:        @omniauth["credentials"]["token"],
      access_token_secret: @omniauth["credentials"]["secret"]
    ).first_or_create
  end

  def user_from_facebook
    user = User.where(
      first_name: @omniauth["info"]["first_name"],
      last_name:  @omniauth["info"]["last_name"],
      email:      @omniauth["info"]["email"],
      image:      @omniauth["info"]["image"].gsub("=square", "=large")
    ).first_or_create

    user = authorizations.where(
      provider: @provider,
      uid:      @omniauth["uid"].to_s
    ).first_or_create
  end

end
