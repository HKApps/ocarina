class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string  :name,     null: false
      t.string  :provider, null: false
      t.string  :path,     null: false
      t.integer :user_id,  null: false
      t.hstore  :properties

      t.timestamps
    end
  end
end
