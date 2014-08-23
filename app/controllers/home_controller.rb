class HomeController < ApplicationController
  def index
    if signed_in?
      @asset = current_customer.assets.build
    end
  end
end
