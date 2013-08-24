class AddPasswordToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :password, :string
  end
end
