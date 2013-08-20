class AddPlaylistIdIndexWithUniquenessToSavedSongs < ActiveRecord::Migration
  def change
    add_index :saved_songs, [:playlist_song_id, :user_id], unique: true
  end
end
