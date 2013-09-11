class ApiController < ApplicationController
  # TODO(mn) - Authenticate API requests
  protect_from_forgery with: :null_session
end
