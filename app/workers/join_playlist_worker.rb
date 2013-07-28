class JoinPlaylistWorker
  include Sidekiq::Worker

  sidekiq_options queue:     :join_playlist_worker,
                  backtrace: true,
                  retry:     true

  def perform(playlist_id, user_id)
    Guest.create! do |g|
      g.playlist_id = playlist_id
      g.user_id     = user_id
    end
  end
end
