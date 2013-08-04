class AddRemovedAtToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :removed_at, :datetime
  end
end
