class CartsController < ApplicationController
  def show
    @cart_items = current_cart.map do |item_id, quantity|
      item = Garment.find(item_id)
      { item: item, quantity: quantity }
    end 
  end
end
