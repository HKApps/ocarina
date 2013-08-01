class Api::UsersController < ApiController
  respond_to :json

  def show
    @user = User.includes(:songs, :playlists, :guests).where(id: params[:id]).first
  end

  def current_user_json
    @user = current_user
  end
end
