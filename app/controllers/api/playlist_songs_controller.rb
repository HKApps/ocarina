class Api::PlaylistSongsController < ApiController
  respond_to :json

  def create
    playlist_id = params[:id]
    playlist_songs = AddPlaylistSongToPlaylistService.initialize_from_params(params).create
    if playlist_songs.present?
      push_playlist_songs(playlist_id, playlist_songs)
      render json: playlist_songs, status: 201
    else
      render json: {error: "record not found"}, status: 404
    end
  end

  def played
    playlist_id = params[:playlist_id]
    song_id = params[:id]
    PlaylistSongPlayedWorker.new.async.perform(song_id)
    push_played_song(playlist_id, song_id.to_i)
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
    PlaylistSongVoterWorker.new.async.perform(vote_params, :upvote)
    push_vote(params[:action], params[:playlist_id], params[:id].to_i)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def downvote
    PlaylistSongVoterWorker.new.async.perform(vote_params, :downvote)
    push_vote(params[:action], params[:playlist_id], params[:id].to_i)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def push_playlist_songs(playlist_id, playlist_songs)
    Pusher.trigger("playlist-#{playlist_id}", "new-playlist-songs", {
      user_id: current_user.id,
      playlist_songs: playlist_songs,
      current_user_vote_decision: 0
    })
  end

  def push_played_song(playlist_id, song_id)
    Pusher.trigger("playlist-#{playlist_id}", "song-played", {
      user_id: current_user.id,
      song_id: song_id })
  end

  def push_vote(action, playlist_id, song_id)
    Pusher.trigger("playlist-#{playlist_id}", "new-vote", {
      user_id: current_user.id,
      action: action,
      song_id: song_id })
  end

  private

  def vote_params
    params.permit(:id).merge(user_id: session[:user_id])
  end

end
