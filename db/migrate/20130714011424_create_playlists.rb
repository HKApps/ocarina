class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.integer :party_id, null: false
      t.integer :song_id, null: false
      t.integer :up_votes, default: 0
      t.integer :down_votes, default: 0
    end

    add_index :playlists, [:party_id, :song_id]
  end
end
