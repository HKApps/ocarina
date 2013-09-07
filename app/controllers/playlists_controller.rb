class PlaylistsController < ApplicationController
  def index_template
    respond_to do |format|
      format.html do
        # if current_user
        #   render :index
        # else
        #   render 'sessions/new', :layout => "sessions"
        # end
        if current_user
          render :indexMobile, :layout => "applicationMobile"
        else
          render 'sessions/new', :layout => "sessions"
        end
      end
    end
  end
end
