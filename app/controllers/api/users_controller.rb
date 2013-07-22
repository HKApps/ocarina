class Api::UsersController < ApiController
  respond_to :json

  def show
    @user = User.find_by(id: params[:id]).try(:status)
    respond_with @user
  end

  def current_user_json
    respond_with current_user.try(:status)
  end
end
