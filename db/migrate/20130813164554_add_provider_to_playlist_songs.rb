class AddProviderToPlaylistSongs < ActiveRecord::Migration
  def change
    add_column :playlist_songs, :provider, :string
  end
end
