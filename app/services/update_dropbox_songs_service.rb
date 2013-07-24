class UpdateDropboxSongsService

  ##
  # Find user dropbox metadata in cache.
  # If cache exists, set dropbox metadata to object & call db.update_metadata;
  # otherwise fetch db md and save to cache.
  def self.perform(user_id)
    service = new(user_id)
    service.update_songs
    service.write_cache(service.dropbox_client.metadata)
    service.convert_to_songs
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def read_cache
    Rails.cache.fetch(cache_key) { DropboxClient::NullMetadata.new }
  end

  def write_cache(new)
    Rails.cache.write(cache_key, new)
  end

  def update_songs
    dropbox_client.metadata = read_cache
    dropbox_client.update_metadata
  end

  def convert_to_songs
    file_to_song_service.convert_and_save
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
