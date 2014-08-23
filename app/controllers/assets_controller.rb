class AssetsController < ApplicationController
 before_action :signed_in_customer, only: [:edit, :update, :show, :destroy]
 before_action :correct_customer, only: [:edit, :update, :show, :destroy]
 before_action :correct_customer_asset, only: [:edit, :update, :show, :destroy]

	def new
		@customer = current_customer
	end

  def asset_crop
  @product = Product.find(params[:prod_id])
  @asset = Asset.find(params[:asset_id])    
  end	

	  def show
	    @asset = current_customer.assets.find_by(id: params[:id])
	  end

	def index
		@assets = current_customer.assets
	end

 def destroy
      if asset = current_customer.assets.find_by(id: params[:id])
          asset.destroy!
      end
      redirect_to current_customer
  end

	 def create
	  @asset = current_customer.assets.build(asset_params)

	  if @asset.save!
	  redirect_to current_customer
	  else
	  render 'new'
	  end
	 end

		  private
		    def asset_params
		      params.require(:asset).permit(:file_name)
		    end

		        def correct_customer_asset
			      @asset = current_customer.assets.find_by(id: params[:id])
			      redirect_to root_url if @asset.nil?
			    end

end