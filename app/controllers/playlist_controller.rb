class PlaylistController < ApplicationController
  respond_to :json

  def index
    @playlist = Playlist.where party_id: params[:party_id]
    respond_with @playlist
  end

  def add_songs
    playlists = AddSongToPlaylistService.initialize_from_params(params).create
    if playlists.present?
      render json: playlists, status: 201
    else
      respond_with({error: "record not found"}, status: 404)
    end
  end

  private

  def add_song_params
    params.require(:party_id, :song_ids)
  end
end
