class AddPlaylistNameToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :playlist_name, :string
  end
end
