class CartsController < ApplicationController
  def show
    @cart_items = []
    session[:cart]&.each do |item_id, quantity|
      item = Garment.find_by(id: item_id)
      next unless item

      @cart_items << { item: item, quantity: quantity }
    end
  end

   
end
