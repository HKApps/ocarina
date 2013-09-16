class PlaylistsController < ApplicationController
  def index_template
    respond_to do |format|
      format.html do
        render :index
      end
    end
  end
end
