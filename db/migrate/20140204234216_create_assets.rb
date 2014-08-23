class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :file_name
      t.integer :customer_id
      t.timestamps
    end
    add_index :assets, :customer_id
  end
end
