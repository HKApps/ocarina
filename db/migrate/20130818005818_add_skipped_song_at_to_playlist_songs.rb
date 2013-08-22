class AddSkippedSongAtToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :skipped_song_at, :datetime
  end
end
