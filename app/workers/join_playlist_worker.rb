class JoinPlaylistWorker
  include SuckerPunch::Job

  #sidekiq_options queue:     :join_playlist_worker,
                  #backtrace: true,
                  #retry:     true

  def perform(playlist_id, user_id)
    playlist = ::Playlist.find playlist_id
    ::Guest.create! do |g|
      g.playlist_id   = playlist.id
      g.playlist_name = playlist.name
      g.user_id       = user_id
    end
  end
end
