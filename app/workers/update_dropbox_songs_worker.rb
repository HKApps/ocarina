class UpdateDropboxSongsWorker
  include Sidekiq::Worker

  sidekiq_options queue:     :update_dropbox_songs_worker,
                  backtrace: true

  def perform(user_id)
    UpdateDropboxSongsService.perform(user_id)
  end

end
