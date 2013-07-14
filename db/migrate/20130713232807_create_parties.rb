class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name, null: false
      t.integer :host_id, null: false
    end

    add_index :parties, :host_id
  end
end
