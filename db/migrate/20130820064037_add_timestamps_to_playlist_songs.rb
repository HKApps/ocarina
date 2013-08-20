class AddTimestampsToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :created_at, :datetime
    add_column :playlist_songs, :updated_at, :datetime
  end
end
