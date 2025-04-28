class CheckoutController < ApplicationController

  def show
    @cart_items = session[:cart].map do |id, quantity|
      item = Garment.find(id)
      { item: item, quantity: quantity }
  end
end
