class AddSongToPlaylistWorker
  include Sidekiq::Worker
  sidekiq_options queue:     :add_song_to_playlist,
                  retry:     true,
                  backtrace: true

  def perform(service)
    ActiveRecord::Base.transaction do
      service.create
    end
  end
end
