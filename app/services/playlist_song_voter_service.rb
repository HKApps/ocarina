class PlaylistSongVoterService
  ##
  # This service does three things:
  # 1. Create Vote object
  # 2. Update counter in PlaylistSong
  # 3. Push out updates to clients using pusher

  def self.from_params(params, decision)
    playlist_song_id = params.delete("id")      { raise "Required param: id"}
    user_id          = params.delete("user_id") { raise "Required param: user_id"}

    new(playlist_song_id, user_id, decision)
  end

  def initialize(playlist_song_id, user_id, decision)
    @playlist_song_id = playlist_song_id
    @user_id          = user_id
    @decision         = Vote.send(decision)
  end

  def create
    vote = Vote.where(user_id: @user_id, playlist_song_id: @playlist_song_id).first_or_initialize
    vote.send(@decision.vote_method)
    vote.valid_decision? ? vote.save! : vote.touch
  end

  def update_vote_counter
    PlaylistSong.send(@decision.action, :vote_count, @playlist_song_id)
  end

  def publish
    # TODO(mn) - Publish pusher event to clients
  end
end
