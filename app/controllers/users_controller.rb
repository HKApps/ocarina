class UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find_by(id: params[:id]).try(:status)
    respond_with @user
  end
end
