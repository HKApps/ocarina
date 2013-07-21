class PlaylistSongVoterWorker
  include Sidekiq::Worker

  sidekiq_options queue:     :playlist_song_voter_worker,
                  backtrace: true

  def perform(params, decision)
    ActiveRecord::Base.transaction do
      service = PlaylistSongVoterService.from_params(params, decision)
      service.create
      service.update_vote_counter
    end
  end
end
