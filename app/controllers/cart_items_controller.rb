class CartItemsController < ApplicationController
  def create
    id = params[:item_id].to_s
    session[:cart] ||= {}
    session[:cart][id] = (session[:cart][id] || 0) + 1
    redirect_to cart_path, notice: "Added to cart."
  end

  def update
    id = params[:item_id].to_s
    quantity = params[:quantity].to_i
    session[:cart][id] = quantity if quantity > 0
    redirect_to cart_path, notice: "Cart updated."
  end

  def destroy
    id = params[:id].to_s
    session[:cart]&.delete(id)
    redirect_to cart_path, notice: "Item removed from cart."
  end
end
