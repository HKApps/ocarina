class CreateVote < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :playlist_song_id, null: false
      t.integer :user_id, null: false
      t.integer :decision, null: false
    end

    add_index :votes, [:playlist_song_id, :user_id], unique: true
  end
end
