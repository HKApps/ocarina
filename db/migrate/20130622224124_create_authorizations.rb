class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations, id: :uuid do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
