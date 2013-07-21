class AddPlaylistSongToPlaylistService
  def self.initialize_from_params(params)
    playlist_id = params.delete(:id)       { raise "Required param: id" }
    song_ids    = params.delete(:song_ids) { raise "Required param: song_ids" }

    new(song_ids.split(','), playlist_id)
  end

  def initialize(song_ids, playlist_id)
    @song_ids = song_ids
    @playlist_id = playlist_id
  end

  def create
    ActiveRecord::Base.transaction do
      songs.map do |song|
        song.playlists_songs.create do |s|
          s.song_path   = song.path
          s.playlist_id = @playlist_id
        end
      end
    end
  end

  def songs
    @songs ||= Song.where(id: @song_ids)
  end

  def songs_with_media_urls(dropbox_client)
    return unless dropbox_client.present?

    songs.map do |song|
      song.attributes.merge({
        media_url: dropbox_client.media_url(song.path)
      })
    end
  end
end
