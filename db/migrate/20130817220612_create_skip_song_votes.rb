class CreateSkipSongVotes < ActiveRecord::Migration
  def change
    create_table :skip_song_votes do |t|
      t.integer :playlist_song_id
      t.integer :user_id
    end

    add_index :skip_song_votes, [:playlist_song_id, :user_id]
  end
end
