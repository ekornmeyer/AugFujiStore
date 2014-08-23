class OrderLinesController < ApplicationController

	def index
		@current_order = session[:cookies_orderid]
  		@db_lines = OrderLine.where("order_id = ?", @current_order)
	end

	def new
		@order_line = OrderLine.new
	end

	def create	
		@current_order = session[:cookies_orderid]
		@qty = params[:Quantity]
		@line_number = params[:LineNumber]

		@update_qty = HTTParty.post("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}/lines/#{@line_number}/?qty=#{@qty}",
		:headers => { "Content-length" => "0" ,
					  "Content-Type" => "text/json",
					  "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })

	 	@order_line = OrderLine.new(order_line_params)
	    if @order_line.save
	     redirect_to shoppingcart_path
	    else
	     redirect_to products_path
	    end
	end

	def update_quantity

		@current_order = session[:cookies_orderid]
		@db_lines = OrderLine.where("order_id = ?", @current_order)

		@order_line_count = 0

		params[:ids_to_update].split(',').each do |paramid|
			@db_line = OrderLine.find(paramid)
			if OrderLine.valid_attribute?(:Quantity, params["updated_quantity#{paramid}"])
			@db_line.update_column(:Quantity, params["updated_quantity#{paramid}".to_sym])
			@order_line_count += 1
			else
			@order_line_count -= 1	
			end
		end

			if @order_line_count == @db_lines.count
			redirect_to shoppingcart_path
			else
			redirect_to shoppingcart_path, :flash => { :error => "Quantity must be a number." }
			end		

	end

	def destroy
		@current_order = session[:cookies_orderid]
		@order_line = OrderLine.find(params[:id])
		@fuji_line = @order_line.LineNumber
		@destroy_line = HTTParty.delete("https://preview.webservices.fujifilmesys.com/spa/v2/Orders/#{@current_order}/lines/#{@fuji_line}/",
		:headers => { "Content-length" => "0" ,
					  "Content-Type" => "text/json",
					  "Authorization" => "ApiKey=6dc08434e25b48ec9c0f209ee83eb5aa" })
		@order_line.destroy()
		redirect_to shoppingcart_path
	end

		private
			def order_line_params
				params.permit(:order_id, :preview_url, :LineNumber, :ProductCode, :Quantity, :UnitPrice, :PageNumber, :AssetNumber, :Name, :HiResImage, :CropMode)
			end

end
