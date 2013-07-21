class AddVotesToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :votes, :integer, default: 0
  end
end
