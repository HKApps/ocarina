class PartialsController < ApplicationController
  def partial
    render "/partials/#{params[:partial]}", layout: false
  end
end
