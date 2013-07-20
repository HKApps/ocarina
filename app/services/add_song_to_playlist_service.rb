class AddSongToPlaylistService
  def self.initialize_from_params(params)
    party_id = params.delete(:party_id) { raise "Required param: party_id" }
    song_ids = params.delete(:song_ids) { raise "Required param: song_ids" }

    new(song_ids.split(','), party_id)
  end

  def initialize(song_ids, party_id)
    @song_ids = song_ids
    @party_id = party_id
  end

  def create
    songs.map do |song|
      song.playlists.create do |s|
        s.song_id   = song.id
        s.song_path = song.path
        s.party_id  = @party_id
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
