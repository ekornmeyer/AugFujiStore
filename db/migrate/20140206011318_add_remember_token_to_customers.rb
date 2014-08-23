class AddRememberTokenToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :remember_token, :string
  	add_index :customers, :remember_token
  end
end
