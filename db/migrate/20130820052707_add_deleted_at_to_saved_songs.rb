class AddDeletedAtToSavedSongs < ActiveRecord::Migration
  def change
    add_column :saved_songs, :deleted_at, :datetime
  end
end
