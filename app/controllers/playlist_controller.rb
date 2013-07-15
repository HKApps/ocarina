class PlaylistController < ApplicationController
  respond_to :json

  def index
    @playlist = Playlist.where party_id: params[:party_id]
    respond_with @playlist
  end
end
