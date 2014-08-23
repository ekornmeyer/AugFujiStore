# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


  @response = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Catalogs/MailOrder?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa")
  @http_party_json = JSON.parse(@response.body)
  @just_products = @http_party_json ['products']
  @http_party_json.each do |i|
        i.each do |x|
   @just_products = x['Products']
   end
  end

  @just_products.each do |product|
    Product.create(:product_code => product['ProductCode'], :name => product['Name'], :description => product['Description'], :unit_price => product['UnitPrice'], :default_img_url => "https://preview.webservices.fujifilmesys.com/spa/v2/catalogs/10024/products/" + product['ProductCode'] + "/assets/Marketing.png", :blank_img_url => "https://preview.webservices.fujifilmesys.com/spa/v2/catalogs/10024/products/" + product['ProductCode'] + "/assets/Display.png")
  end

  products = Product.all
  products.each do |prod|
    pids = prod.id.to_i
    case pids
    when 1
     prod.update_column(:category_id, '3')
    when 2
     prod.update_column(:category_id, '3')   
    when 3
     prod.update_column(:category_id, '2')
    when 4
     prod.update_column(:category_id, '1')     
    when 5
     prod.update_column(:category_id, '1')
    when 6
     prod.update_column(:category_id, '1')   
    when 7
     prod.update_column(:category_id, '1')
    when 8
     prod.update_column(:category_id, '1')     
    when 9
     prod.update_column(:category_id, '1')
    when 10
     prod.update_column(:category_id, '1')   
    when 11
     prod.update_column(:category_id, '4')
    when 12
     prod.update_column(:category_id, '5')     
    when 13
     prod.update_column(:category_id, '6')
    when 14
     prod.update_column(:category_id, '6')   
    when 15
     prod.update_column(:category_id, '6')
    when 16
     prod.update_column(:category_id, '10')    
    when 17
     prod.update_column(:category_id, '10')     
    when 18
     prod.update_column(:category_id, '10')
    when 19
     prod.update_column(:category_id, '8')   
    when 20
     prod.update_column(:category_id, '1')
    when 21
     prod.update_column(:category_id, '7')     
    when 22
     prod.update_column(:category_id, '8')
    when 23
     prod.update_column(:category_id, '8')   
    when 24
     prod.update_column(:category_id, '9')
    when 25
     prod.update_column(:category_id, '2')
    else                       
    end
  end

  categories = Category.create([{ title: 'Mugs' }, { title: 'Mousepads' }, { title: 'Magnets' }, { title: 'Water Bottles' }, { title: 'Puzzless' }, { title: 'Ornaments' }, { title: 'Post Cards' }, { title: 'Easels' }, { title: 'Posters' }, { title: 'Prints' }])