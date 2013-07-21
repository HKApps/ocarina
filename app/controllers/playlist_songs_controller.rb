class PlaylistSongsController < ApplicationController
  def create
    playlist_songs = AddPlaylistSongToPlaylistService.initialize_from_params(params).create
    if playlist_songs.present?
      render json: playlist_songs, status: 201
    else
      respond_with({error: "record not found"}, status: 404)
    end
  end

  def up
    PlaylistSongVoterWorker.perform_async(vote_params, :up)
    respond_to do |format|
      format.json { render json: {status: "ok"} }
    end
  end

  def down
    PlaylistSongVoterWorker.perform_async(vote_params, :down)
    respond_to do |format|
      format.json { render json: {status: "ok"} }
    end
  end

  private

  def vote_params
    params.permit(:id).merge(user_id: session[:user_id])
  end
end
