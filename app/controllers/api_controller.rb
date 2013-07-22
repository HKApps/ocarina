class ApiController < ApplicationController
  before_filter :require_authorization

  protected

  def require_authorization
    render(json: {}, status: :unauthorized) unless current_user
  end
end
