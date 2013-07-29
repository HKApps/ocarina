class Api::PlaylistSongsController < ApiController
  respond_to :json

  def create
    playlist_id = params[:id]
    playlist_songs = AddPlaylistSongToPlaylistService.initialize_from_params(params).create
    if playlist_songs.present?
      push_playlist_songs(playlist_songs)
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
    push_vote(params[:action], params[:id].to_i)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def downvote
    PlaylistSongVoterWorker.perform_async(vote_params, :downvote)
    push_vote(params[:action], params[:id].to_i)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def push_vote(action, song_id)
    Pusher.trigger("playlist-#{params[:playlist_id]}", "new-vote", {
      user_id: current_user.id,
      action: action,
      song_id: song_id })
  end

  def push_playlist_songs(playlist_songs)
    Pusher.trigger("playlist-#{playlist_id}", "new-playlist-songs", {
      user_id: current_user.id,
      playlist_songs: playlist_songs })
  end

  private

  def vote_params
    params.permit(:id).merge(user_id: session[:user_id])
  end

end
