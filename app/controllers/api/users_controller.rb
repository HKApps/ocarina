class Api::UsersController < ApiController
  respond_to :json

  def show
    @user = User.includes(:songs, :playlists, :guests).where(id: params[:id]).first
  end

  def current_user_json
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    unless @user.save
      respond_with user.errors, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :image)
  end

end
