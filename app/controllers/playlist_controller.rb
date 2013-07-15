class PlaylistController < ApplicationController
  respond_to :json

  def index
    @playlist = Playlist.where party_id: params[:party_id]
    respond_with @playlist
  end

  def add_songs
    AddSongToPlaylistService.create_from_params(params)
    redirect_to party_path(params[:party_id])
  end
end
