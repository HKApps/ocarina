class AddPlaylistSongToPlaylistService
  def self.initialize_from_params(params, user_id, dropbox_client)
    playlist_id = params.delete(:id)         { raise "Required param: id" }
    dropbox     = params.delete(:dropbox)    { raise "Required param: dropbox" }
    soundcloud  = params.delete(:soundcloud) { raise "Required param: soundcloud" }

    new(dropbox, soundcloud, playlist_id, user_id, dropbox_client)
  end

  def initialize(dropbox, soundcloud, playlist_id, user_id, dropbox_client)
    @dropbox        = dropbox
    @soundcloud     = soundcloud
    @playlist_id    = playlist_id
    @user_id        = user_id
    @dropbox_client = dropbox_client
    @playlist_songs = []
  end

  def create
    create_from_dropbox   if @dropbox
    create_from_souncloud if @soundcloud
    @playlist_songs
  end

  def create_from_dropbox
    ActiveRecord::Base.transaction do
      dropbox_songs.map do |song|
        add_playlist_song_to_playlist(song)
      end
    end
  end

  def create_from_souncloud
    ActiveRecord::Base.transaction do
      @soundcloud.map do |sc|
        song = Song.find_or_initialize_from_soundcloud(sc, @user_id)
        add_playlist_song_to_playlist(song)
      end
    end
  end

  def add_playlist_song_to_playlist(song)
    playlist_song = PlaylistSong.where(playlist_id: @playlist_id, song_id: song.id).first_or_initialize.tap do |ps|
      ps.path        = song.path
      ps.song_name   = song.name
      ps.provider    = song.provider
      ps.media_url   = set_media_url(song)
      ps.changed? ? ps.save! : ps.touch
    end.attributes
    playlist_song["current_user_vote_decision"] = 0
    @playlist_songs << playlist_song
  end

  def set_media_url(song)
    case song.provider
    when "soundcloud" then "#{song.path}/stream?client_id=3d6e76640c62f42c02cb78d2c53d0db9"
    when "dropbox"    then @dropbox_client.media_url(song.path)['url']
    end
  end

  def dropbox_songs
    @dropbox_songs ||= Song.where(id: @dropbox)
  end

end
