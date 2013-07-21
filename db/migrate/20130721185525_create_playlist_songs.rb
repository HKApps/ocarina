class CreatePlaylistSongs < ActiveRecord::Migration
  def change
    create_table :playlist_songs do |t|
      t.integer :playlist_id, null: false
      t.integer :song_id, null: false
      t.integer :vote_count, null: false, default: 0
      t.string :path, null: false
      t.string :media_url
    end
  end
end
