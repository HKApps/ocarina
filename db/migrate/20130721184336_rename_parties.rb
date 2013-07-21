class RenameParties < ActiveRecord::Migration
  def change
    rename_table :parties, :playlists
  end
end
