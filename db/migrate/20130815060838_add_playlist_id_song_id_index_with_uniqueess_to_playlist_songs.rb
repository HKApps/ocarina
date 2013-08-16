class AddPlaylistIdSongIdIndexWithUniqueessToPlaylistSongs < ActiveRecord::Migration
  def change
    add_index :playlist_songs, [:playlist_id, :song_id], unique: true
  end
end
