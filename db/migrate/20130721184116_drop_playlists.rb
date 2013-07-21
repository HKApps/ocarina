class DropPlaylists < ActiveRecord::Migration
  def up
    drop_table :playlists
  end

  def down
    create_table :playlists do |t|
      t.integer :party_id, null: false
      t.integer :song_id, null: false
      t.integer :up_votes, default: 0
      t.integer :down_votes, default: 0
      t.string  :song_path
    end

    add_index :playlists, [:party_id, :song_id]
  end
end
