class CheckoutController < ApplicationController
  
  def show
    @garment = Garment.find(params[:garment_id])
  end
end
