class AddIndexOnPlaylistIdAndSongIdInPlaylistSongs < ActiveRecord::Migration
  def change
    add_index :playlist_songs, [:song_id, :playlist_id]
  end
end
