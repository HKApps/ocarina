class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"
    create_table :users, id: :uuid do |t|
      t.string :email,  null: false
      t.string :first_name
      t.string :last_name
      t.string :image

      t.timestamps
    end
  end
end
