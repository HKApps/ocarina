class AddIndexOnUserIdInGuests < ActiveRecord::Migration
  def change
    add_index :guests, :user_id
  end
end
