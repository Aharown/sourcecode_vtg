class CartItemsController < ApplicationController
  def create
    id = params[:item_id].to_s
    session[:cart] ||= {}
    session[:cart][id] ||= 1

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: { added: true } }
    end
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
