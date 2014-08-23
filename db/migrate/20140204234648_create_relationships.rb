class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :customer_id
      t.integer :asset_id
      t.timestamps
    end
    add_index :relationships, :customer_id
    add_index :relationships, :asset_id
    add_index :relationships, [:customer_id, :asset_id], unique: true
  end
end
