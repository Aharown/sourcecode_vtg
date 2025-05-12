class CartItemsController < ApplicationController
  def create
    id = params[:item_id].to_s
    session[:cart] ||= {}

    if session[:cart].key?(id)
    else
      session[:cart][id] = 1
    end

    redirect_to cart_path
  end

  def update
    id = params[:id].to_s
    session[:cart][id] = 1
    redirect_to cart_path
  end

  def destroy
    id = params[:id].to_s
    session[:cart]&.delete(id)
    redirect_to cart_path
  end
end
