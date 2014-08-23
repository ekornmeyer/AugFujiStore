class CreateBillingAddresses < ActiveRecord::Migration
  def change
    create_table :billing_addresses do |t|
      t.integer :customer_id
      t.string :bi_first_name
      t.string :bi_last_name
      t.string :bi_email
      t.string :bi_phone    	
      t.string :bi_address1
      t.string :bi_address2
      t.string :bi_city
      t.string :bi_state
      t.integer :bi_zipcode
      t.timestamps
    end
    add_index :billing_addresses, :customer_id
  end
end
