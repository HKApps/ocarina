class Api::PlaylistSongsController < ApiController
  respond_to :json

  def create
    playlist_songs = AddPlaylistSongToPlaylistService.initialize_from_params(params).create
    if playlist_songs.present?
      render json: playlist_songs, status: 201
    else
      render json: {error: "record not found"}, status: 404
    end
  end

  def played
    PlaylistSongPlayedWorker.perform_async(params[:id])
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def media_url
    ps = PlaylistSong.find_by id: params[:id]
    @media_url = dropbox_client.media_url ps.path
    respond_with @media_url
  end

  def upvote
    PlaylistSongVoterWorker.perform_async(vote_params, :upvote)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def downvote
    PlaylistSongVoterWorker.perform_async(vote_params, :downvote)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  private

  def vote_params
    params.permit(:id).merge(user_id: session[:user_id])
  end

end
