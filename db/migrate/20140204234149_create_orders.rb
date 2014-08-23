class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
	  t.integer :customer_id
	  t.string :fuji_order
	  t.float :items_amount
	  t.float :total_tax
	  t.float :total_shipping
	  t.float :total_price
	  t.integer :shipping_address_id
	  t.integer :billing_address_id
      t.timestamps
    end
    add_index :orders, :customer_id
  end
end
