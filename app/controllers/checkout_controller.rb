class CheckoutController < ApplicationController
  def show
    @cart_items = (session[:cart] || {}).map do |id, quantity|
      item = Garment.find_by(id: id)
      next unless item

      { item: item, quantity: quantity }
    end.compact 
  end
end
