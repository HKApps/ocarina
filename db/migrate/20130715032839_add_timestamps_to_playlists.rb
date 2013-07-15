class AddTimestampsToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :created_at, :datetime
    add_column :playlists, :updated_at, :datetime
  end
end
