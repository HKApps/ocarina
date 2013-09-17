class Api::PlaylistSongsController < ApiController
  respond_to :json

  def create
    playlist_id = params[:id]
    playlist_songs = AddPlaylistSongToPlaylistService.initialize_from_params(params, user_id, dropbox_client).create
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

  def skip_song_vote
    SkipSongVoterWorker.new.async.perform(skip_song_params)
    respond_to do |format|
      format.json { head :ok }
    end
  end

  private

  def push_playlist_songs(playlist_id, playlist_songs)
    Pusher.trigger("playlist-#{playlist_id}", "new-playlist-songs", {
      user_id: user_id,
      playlist_songs: playlist_songs,
      current_user_vote_decision: 0
    })
  end

  def push_played_song(playlist_id, song_id)
    Pusher.trigger("playlist-#{playlist_id}", "song-played", {
      user_id: user_id,
      song_id: song_id })
  end

  def push_vote(action, playlist_id, song_id)
    Pusher.trigger("playlist-#{playlist_id}", "new-vote", {
      user_id: user_id,
      action: action,
      song_id: song_id })
  end

  def vote_params
    params.permit(:id).merge(user_id: user_id)
  end

  def skip_song_params
    params.permit(:id, :playlist_id, :user_id)
  end

end
