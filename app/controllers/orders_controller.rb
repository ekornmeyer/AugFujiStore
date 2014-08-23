class OrdersController < ApplicationController
 before_action :signed_in_customer
 before_action :correct_customer

  def index
    @orders = current_customer.orders    
  end

	def new

		if session[:cookies_orderid].nil?
			redirect_to '/shoppingcart'
		else
			  @current_order = session[:cookies_orderid]
	  		@db_lines = OrderLine.where("order_id = ?", @current_order)
	  		@customer = current_customer
		    @assets = current_customer.assets
		    @shipping_addresses = current_customer.shipping_addresses
		    @billing_addresses = current_customer.billing_addresses

        @get_order = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa")
		end

	end

    def create  
    @current_order = session[:cookies_orderid]

    @get_order = HTTParty.get("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}?ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa")    

    @checkout = HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}/checkout/",
    :body => {
      :PaymentMethod => "CC",
      :PaymentData => params[:Credit_Card_Number],
      :PaymentExpirationDate => "#{params[:Expiration_Month]}#{params[:Expiration_Year]}",
      :CreditCardSecurityCode => params[:Security_Code],
      :TotalPrice => @get_order['Order']['OrderDetails']['OrderTotal']['TotalPrice']
    }.to_json,
    :headers => { "Content-length" => "0" ,
            "Content-Type" => "text/json",
            "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

      @order = current_customer.orders.build(:fuji_order => @current_order, :items_amount => @get_order['Order']['OrderDetails']['OrderTotal']['TotalItemPrice'], :total_tax => @get_order['Order']['OrderDetails']['OrderTotal']['TotalTax'], :total_shipping => @get_order['Order']['OrderDetails']['OrderTotal']['TotalShipping'], :total_price => @get_order['Order']['OrderDetails']['OrderTotal']['TotalPrice'], :shipping_address_id => session[:sh_id], :billing_address_id => session[:bi_id])

      if @checkout['Status']['Code'] == 200
      if @order.save
       session.delete(:cookies_orderid)
       redirect_to '/thank_you'
      else
       redirect_to '/checkout'
      end
    end
  end

  def use_sh_address

  @sh_address = ShippingAddress.find(params[:sh_addr_id])
  session[:sh_id] = @sh_address.id

  @update_ship_to = HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/" + session[:cookies_orderid],
              :body =>
              {"ShipTo" =>
             	{
             	 :FirstName => @sh_address.sh_first_name,
             	 :LastName => @sh_address.sh_last_name,
             	 :Phone => @sh_address.sh_phone,
             	 :Email => @sh_address.sh_email,
             	 :Address =>
             	 	{
             	 		:Line1 => @sh_address.sh_address1,
             	 		:Line2 => @sh_address.sh_address2,
             	 		:City => @sh_address.sh_city,
             	 		:State => @sh_address.sh_state,
             	 		:PostalCode => @sh_address.sh_zipcode,
             	 		:Country => "US"
             	 	}
             	}
             }.to_json,
        :headers => { "Content-Type" => "application/json",
                      "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

    respond_to do |format|
      format.js
    end

  end	

  def use_bi_address

  @bi_address = BillingAddress.find(params[:bi_addr_id])
  session[:bi_id] = @bi_address.id

  @update_bill_to = HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/" + session[:cookies_orderid],
              :body =>
              {"BillTo" =>
             	{
             	 :FirstName => @bi_address.bi_first_name,
             	 :LastName => @bi_address.bi_last_name,
             	 :Phone => @bi_address.bi_phone,
             	 :Email => @bi_address.bi_email,
             	 :Address =>
             	 	{
             	 		:Line1 => @bi_address.bi_address1,
                  :City => @bi_address.bi_city,
             	 		:Line2 => @bi_address.bi_address2,
             	 		:State => @bi_address.bi_state,
             	 		:PostalCode => @bi_address.bi_zipcode,
             	 		:Country => "US"
             	 	}
             	}
             }.to_json,
        :headers => { "Content-Type" => "application/json",
                      "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

    respond_to do |format|
      format.js
    end

  end	

  def thank_you

  end

end
