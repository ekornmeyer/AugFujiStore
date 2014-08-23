class CreateOrderLines < ActiveRecord::Migration
  def change
    create_table :order_lines do |t|
      t.string :order_id
      t.integer :LineNumber
      t.string :preview_url
      t.string :ProductCode
      t.integer :Quantity
      t.float :UnitPrice
      t.integer :PageNumber
      t.integer :AssetNumber
      t.string :Name
      t.string :HiResImage
      t.string :CropMode
      t.timestamps
    end
  end
end
