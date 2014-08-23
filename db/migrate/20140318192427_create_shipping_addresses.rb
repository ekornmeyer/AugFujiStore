class CreateShippingAddresses < ActiveRecord::Migration
  def change
    create_table :shipping_addresses do |t|
      t.integer :customer_id
      t.string :sh_first_name
      t.string :sh_last_name
      t.string :sh_email
      t.string :sh_phone   	
      t.string :sh_address1
      t.string :sh_address2
      t.string :sh_city
      t.string :sh_state
      t.integer :sh_zipcode
      t.timestamps
    end
    add_index :shipping_addresses, :customer_id
  end
end
