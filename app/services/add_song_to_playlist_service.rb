class AddSongToPlaylistService
  def self.create_from_params(params)
    party_id = params.delete(:party_id) { raise "Required param: party_id" }
    song_ids = params.delete(:song_ids) { raise "Required param: song_ids" }

    new(song_ids.split(','), party_id).create
  end

  def initialize(song_ids, party_id)
    @song_ids = song_ids
    @party_id = party_id
  end

  def create
    @song_ids.each { |id| Playlist.create(song_id: id, party_id: @party_id) }
  end
end
