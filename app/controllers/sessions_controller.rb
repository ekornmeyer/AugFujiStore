class SessionsController < ApplicationController

  def new
  	
  end

  def create
    customer = Customer.find_by(email: params[:session][:email].downcase)
    if customer && customer.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in customer
      redirect_back_or customer
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
