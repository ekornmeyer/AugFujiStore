class BillingAddressesController < ApplicationController
 before_action :signed_in_customer, only: [:edit, :update, :show, :destroy]
 before_action :correct_customer, only: [:edit, :update, :show, :destroy]

 	def new
		@customer = current_customer
	end

  def update
    session[:return_to] ||= request.referer
    @bi_address = BillingAddress.find(params[:id])
    if @bi_address.update_attributes(bi_u_params)
      redirect_to session.delete(:return_to)
    else
      redirect_to session.delete(:return_to)
    end
  end

	 def create
	  @billing_address = current_customer.billing_addresses.build(bi_params)
      session[:return_to] ||= request.referer
	  if @billing_address.save!
      redirect_to session.delete(:return_to)
	  else
	  render 'new'
	  end
	 end

		  private

		    def bi_params
		      params.require(:billing_address).permit(:bi_address1, :bi_address2, :bi_city, :bi_state, :bi_zipcode, :bi_phone, :bi_email, :bi_first_name, :bi_last_name)
		    end

		    def bi_u_params
			params.permit(:bi_address1, :bi_address2, :bi_city, :bi_state, :bi_zipcode, :bi_phone, :bi_email)
		    end		    
end
