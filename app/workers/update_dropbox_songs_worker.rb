require 'extensions/hash'

class UpdateDropboxSongsWorker
  include Sidekiq::Worker

  sidekiq_options queue:     :update_dropbox_songs_worker,
                  backtrace: true

  ##
  # Find user dropbox metadata in cache.
  # If cache exists, set dropbox metadata to object & call db.update_metadata;
  # otherwise fetch db md and save to cache.
  def perform(user_id)
    @user_id = user_id

    return unless user && dropbox_auth

    cache = Rails.cache.fetch(cache_key) { stringify_metadata_values! dropbox_client.metadata }
    dropbox_client.metadata = cache
    Rails.cache.write(cache_key, dropbox_client.metadata) if dropbox_client.update_metadata

    file_to_song_service.convert_and_save
  end

  def stringify_metadata_values!(metadata)
    metadata.tap { |meta| meta["contents"] = meta["contents"].map { |hash| hash.stringify_values! } }
  end

  def user
    @user ||= User.find_by id: @user_id
  end

  def dropbox_auth
    @dropbox_auth ||= Authentication.find_by user_id: user.id, provider: 'dropbox'
  end

  def dropbox_client
    @dropbox_client ||= DropboxClient.new(dropbox_auth.access_token, dropbox_auth.access_token_secret)
  end

  def file_to_song_service
    FileToSongService.new(dropbox_client.all_song_files, user)
  end

  def cache_key
    "#{user.id}:#{dropbox_auth.uid}"
  end
end
