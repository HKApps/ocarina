class Api::UsersController < ApiController
  respond_to :json

  def show
    @user = User.includes(:songs, :playlists, :guests).where(id: params[:id]).first
  end

  def authenticate
    @user = ApiAuthenticationService.user_from_params(params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :image)
  end

end
