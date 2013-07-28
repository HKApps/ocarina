class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.integer :user_id, null: false
      t.integer :playlist_id, null: false
    end

    add_index :guests, [:user_id, :playlist_id]
  end
end
