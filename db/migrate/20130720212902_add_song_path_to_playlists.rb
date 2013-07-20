class AddSongPathToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :song_path, :string
  end
end
