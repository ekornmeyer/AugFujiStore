module SessionsHelper

    def signed_in_customer
      unless signed_in?
        store_location
        redirect_to signin_url, :flash => { :error => "Please sign in." }
      end
    end

  def sign_in(customer)
    remember_token = Customer.new_remember_token
    cookies[:remember_token] = { value: remember_token, expires: 3.hours.from_now }
    customer.update_attribute(:remember_token, Customer.encrypt(remember_token))
    self.current_customer = customer
  end

  def signed_in?
  	!current_customer.nil?
  end

  def current_customer=(customer)
  	@current_customer = customer
  end

  def current_customer
    remember_token = Customer.encrypt(cookies[:remember_token])
    @current_customer ||= Customer.find_by(remember_token: remember_token)
  end

    def correct_customer
      @customer = @current_customer
      redirect_to(root_url) unless current_customer?(@customer)
    end

  def current_customer?(customer)
    customer == current_customer
  end

  def sign_out
    current_customer.update_attribute(:remember_token, Customer.encrypt(Customer.new_remember_token))
    cookies.delete(:remember_token)
    session.delete(:cookies_orderid)
    self.current_customer = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def load_products
    @category = Category.find(params[:category_id])
    @products = Product.where("category_id = ?", @category.id)

    respond_to do |format|
      format.js
    end    
  end

  def image_process
    @product = Product.find(params[:prod_id])
    @asset = Asset.find(params[:asset_id])    
  end

  def crop_image
    @asset = Asset.find(params[:assetid])      
    @mycropimage = MiniMagick::Image.open("public/#{@asset.file_name.url}")
    @mycropimage.crop("#{params[:w]}x#{params[:h]}+#{params[:x1]}+#{params[:y1]}")
    @mycropimage.write("public/uploads/asset/file_name/#{@asset.id}/mycropped_#{@asset.file_name.file.filename}")
    respond_to do |format|
      format.js
    end
  end

 def order_process
 if session[:cookies_orderid].nil? and signed_in? # Check if we have an Order ID from Fuji in the session. If not, do:
  @new_order = HTTParty.post(   "https://preview.webservices.fujifilmesys.com/spa/v2/Orders?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa",
  :headers => { "Content-length" => "0" }) # Create the order with Fuji ^
  #~ @order_id = @new_order['OrderID']
  session[:cookies_orderid] = @new_order['OrderID']
  session[:cart_lines] = Array.new
  @product = Product.find(params[:prod_id])
  @asset = Asset.find(params[:asset_id])

  HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/" + session[:cookies_orderid] + "/lines?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa", # Create a new line into the order with Fuji API. If we are just creating a line we don't need to get anything first.
            :body => { # The body of the request
            :ProductCode => @product.product_code, # Fuji expects a field called ProductCode back so we are pulling the last product code from our session array.
            :Quantity => "1", # Fuji expects a field called Quantity back so we are pulling the last quantity from our second session array.
            :UnitPrice => @product.unit_price, # Fuji expects a field called UnitPrice back so we are pulling the unit price from our database.
            :Pages => # Not exactly on the below yet. This is test info
            [
                {
                    :PageNumber => "1",
                    :Assets =>
                    [
                        { 
                            :AssetNumber => @asset.id,
                            :Name => @asset.file_name.file.filename,
                            :HiResImage => "https://infinite-beyond-6418.herokuapp.com#{@asset.file_name.url}", 
                            :CropMode => "FILLIN"
                        }
                    ]
                }
            ]
        }.to_json,
      :headers => { 'Content-Type' => 'application/json' })

  redirect_to @product
  else
    @product = Product.find(params[:prod_id])
    @asset = Asset.find(params[:asset_id])   

  HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/" + session[:cookies_orderid] + "/lines?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa", # Create a new line into the order with Fuji API. If we are just creating a line we don't need to get anything first.
            :body => { # The body of the request
            :ProductCode => @product.product_code, # Fuji expects a field called ProductCode back so we are pulling the last product code from our session array.
            :Quantity => "1", # Fuji expects a field called Quantity back so we are pulling the last quantity from our second session array.
            :UnitPrice => @product.unit_price, # Fuji expects a field called UnitPrice back so we are pulling the unit price from our database.
            :Pages => # Not exactly on the below yet. This is test info
            [
                {
                    :PageNumber => "1",
                    :Assets =>
                    [
                        { 
                            :AssetNumber => @asset.id,
                            :Name => @asset.file_name.file.filename,
                            :HiResImage => "https://infinite-beyond-6418.herokuapp.com#{@asset.file_name.url}", 
                            :CropMode => "FILLIN"
                        }
                    ]
                }
            ]
        }.to_json,
      :headers => { 'Content-Type' => 'application/json' })

    redirect_to @product
  end 
 end 

end
