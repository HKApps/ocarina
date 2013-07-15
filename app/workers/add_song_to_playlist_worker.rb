class AddSongToPlaylistWorker
  include Sidekiq::Worker
  sidekiq_options queue:     :add_song_to_playlist,
                  retry:     true,
                  backtrace: true

  def perform(params)
    AddSongToPlaylistService.create_from_params(params)
  end
end
