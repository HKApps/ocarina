class PlaylistSongPlayedWorker
  include SuckerPunch::Job

  def perform(playlist_song_id)
    playlist_song = ::PlaylistSong.find playlist_song_id
    playlist_song.played!
  end
end
