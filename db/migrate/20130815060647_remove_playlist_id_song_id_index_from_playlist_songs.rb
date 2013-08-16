class RemovePlaylistIdSongIdIndexFromPlaylistSongs < ActiveRecord::Migration
  def change
    remove_index :playlist_songs, name: "index_playlist_songs_on_song_id_and_playlist_id"
  end
end
