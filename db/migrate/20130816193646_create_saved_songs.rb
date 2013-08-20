class CreateSavedSongs < ActiveRecord::Migration
  def change
    create_table :saved_songs do |t|
      t.integer :playlist_song_id, null: false
      t.integer :user_id, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
