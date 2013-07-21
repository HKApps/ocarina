class RenameHostToOwnerInPlaylists < ActiveRecord::Migration
  def change
    rename_column :playlists, :host_id, :owner_id
  end
end
