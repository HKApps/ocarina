class PlaylistController < ApplicationController
  respond_to :json

  def index
    @playlist = Playlist.where party_id: params[:party_id]
    respond_with @playlist
  end

  def add_songs
    service = AddSongToPlaylistService.initialize_from_params(params)
    @songs = service.songs_with_media_urls(dropbox_client)
    if @songs
      AddSongToPlaylistWorker.perform_async(service)
      respond_with @songs
    else
      respond_with({}, status: :unauthorized)
    end
  end

  private

  def add_song_params
    params.require(:party_id, :song_ids)
  end
end
