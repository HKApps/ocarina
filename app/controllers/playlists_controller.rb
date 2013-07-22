class PlaylistsController < ApplicationController
  def index_template
    respond_to do |format|
      format.html do
        if current_user
          render :index
        else
          render 'sessions/new', :layout => "logged_out"
        end
      end
    end
  end
end
