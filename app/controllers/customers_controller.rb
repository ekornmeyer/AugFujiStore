class CustomersController < ApplicationController
 before_action :signed_in_customer, only: [:edit, :update, :show]
 before_action :correct_customer,   only: [:edit, :update, :show]

  def show
    @customer = current_customer
    @assets = current_customer.assets
    @orders = current_customer.orders
    @shipping_addresses = current_customer.shipping_addresses
    @billing_addresses = current_customer.billing_addresses
  end

  def new
   @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
     sign_in @customer
     redirect_to @customer
    else
     render 'new'
    end
  end

  def edit
    @customer = current_customer
    @shipping_addresses = current_customer.shipping_addresses
    @billing_addresses = current_customer.billing_addresses 
  end

  def update
    session[:return_to] ||= request.referer
    if @customer.update_attributes(updated_params)
      redirect_to session.delete(:return_to)
    else
      render 'edit'
    end
  end

  def get_sh_address
    @sh_address = ShippingAddress.find(params[:sh_addr_id])
    respond_to do |format|
      format.js
    end    
  end

  def get_bi_address
    @bi_address = BillingAddress.find(params[:bi_addr_id])
    respond_to do |format|
      format.js
    end    
  end  

  private
    def customer_params
      params.require(:customer).permit(:username,:email,:password,:password_confirmation)
    end

    def updated_params
      params.require(:customer).permit(:password,:password_confirmation,:first_name,:last_name,:phone, shipping_addresses_attributes: [:sh_address1,:sh_address2,:sh_city,:sh_state,:sh_zipcode], billing_addresses_attributes: [:bi_address1,:bi_address2,:bi_city,:bi_state,:bi_zipcode])
    end

end