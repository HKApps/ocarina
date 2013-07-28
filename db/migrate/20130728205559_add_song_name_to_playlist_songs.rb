class AddSongNameToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :song_name, :string
  end
end
