class ShippingAddressesController < ApplicationController
 before_action :signed_in_customer, only: [:edit, :update, :show, :destroy]
 before_action :correct_customer, only: [:edit, :update, :show, :destroy]

 	def new
		@customer = current_customer
	end

  def update
    session[:return_to] ||= request.referer
    @sh_address = ShippingAddress.find(params[:id])
    if @sh_address.update_attributes(sh_u_params)
      redirect_to session.delete(:return_to)
    else
      redirect_to session.delete(:return_to)
    end
  end

	 def create
	  @shipping_address = current_customer.shipping_addresses.build(sh_params)
      session[:return_to] ||= request.referer
	  if @shipping_address.save!
      redirect_to session.delete(:return_to)
	  else
	  render 'new'
	  end
	 end

		  private

		    def sh_params
		      params.require(:shipping_address).permit(:sh_address1, :sh_address2, :sh_city, :sh_state, :sh_zipcode, :sh_phone, :sh_email, :sh_first_name, :sh_last_name)
		    end

		    def sh_u_params
			params.permit(:sh_address1, :sh_address2, :sh_city, :sh_state, :sh_zipcode, :sh_phone, :sh_email)
		    end
end
