require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do

  describe "GET #show" do
    it "renders the checkout page successfully with cart items" do
      category = Category.create!(name: "Vintage")
      garment = Garment.create!(title: "Vintage Jacket", price: 5000, category: category)
      session[:cart] = { garment.id.to_s => 2 }

      get :show

      expect(response).to have_http_status(:ok)
      expect(assigns(:cart_items)).to include(
        a_hash_including(item: garment, quantity: 2)
      )
    end

    it "handles empty carts gracefully" do
      session[:cart] = {}

      get :show

      expect(response).to have_http_status(:ok)
      expect(assigns(:cart_items)).to eq([])
    end
  end
end
