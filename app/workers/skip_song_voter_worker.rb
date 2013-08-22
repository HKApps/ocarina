class SkipSongVoterWorker
  include SuckerPunch::Job

  def perform(params)
    playlist_song_id = params.delete("id")          { raise "Required param: id"}
    user_id          = params.delete("user_id")     { raise "Required param: user_id"}
    playlist_id      = params.delete("playlist_id") { raise "Required param: playlist_id"}

    playlist_song = PlaylistSong.find playlist_song_id

    ::ActiveRecord::Base.transaction do
      skip_song_vote = SkipSongVote.new do |ssv|
        ssv.playlist_song_id = playlist_song_id
        ssv.user_id          = user_id
      end

      return unless skip_song_vote.save

      playlist_song.skip_song_vote_count += 1

      guest_count = Guest.where(playlist_id: playlist_id).count

      # Skips song if skip_song_votes exceeds 50% + 1 threshold of total guests + host
      if playlist_song.skip_song_vote_count > ((guest_count + 1).to_f / 2).floor
        Rails.logger.info "Song skipped: #{playlist_song.id}"
        playlist_song.skipped_song_at = Time.now
        push_skipped_song(playlist_id, playlist_song_id, user_id)
      end

      playlist_song.save!
    end
  end

  def push_skipped_song(playlist_id, playlist_song_id, user_id)
    Pusher.trigger("playlist-#{playlist_id}", "skip-song", {
      user_id: user_id.to_i,
      song_id: playlist_song_id.to_i
    })
  end
end
