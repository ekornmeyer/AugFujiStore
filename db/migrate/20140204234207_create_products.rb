class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
	 t.string "product_code"
	 t.string "name"
	 t.string "description", :limit => 500
	 t.string "unit_price"
	 t.string "default_img_url"
	 t.string "blank_img_url"
      t.integer :optimum_dpi
      t.integer :min_dpi
      t.integer :rendered_width
      t.integer :rendered_height
      t.integer :bleed_width
      t.integer :bleed_height
      t.integer :safety_width
      t.integer :safety_height	 
      t.integer :category_id
      t.timestamps
    end
  end
end
