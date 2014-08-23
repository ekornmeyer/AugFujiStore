class ProductsController < ApplicationController
 before_action :signed_in_customer, only: [:image_process, :crop_image, :order_process]
 before_action :correct_customer, only: [:image_process, :crop_image, :order_process]

 def index
  @products = Product.all
  @categories = Category.all.order('title ASC')
  @products_json = @products.as_json
 end
 
 def show
  @product = Product.find(params[:id])
  @assets = current_customer.assets if signed_in?
  @current_order = session[:cookies_orderid]
  @db_lines = OrderLine.where("order_id = ?", @current_order)
  @get_lines = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}/lines?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa")
 end

end