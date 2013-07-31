class AddPlayedAtToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :played_at, :datetime
  end
end
