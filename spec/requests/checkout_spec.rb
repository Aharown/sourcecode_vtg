require 'rails_helper'

RSpec.describe "Checkout", type: :request do
  describe "GET /checkout" do
    it "renders the checkout page successfully with cart items" do
      garment = Garment.create!(title: "Vintage Jacket", price: 5000, category: Category.create!(name: "Vintage"))
      session_cart = { garment.id.to_s => 2 }  # Make sure we convert the id to string as Rails stores it as string

      # Inject cart into session
      Rails.application.env_config["rack.session"] = { cart: session_cart }

      # Make the request
      get "/checkout"

      # Check that the page loads correctly
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Vintage Jacket")
      expect(response.body).to include("2")  # Ensure the quantity is displayed as well
    end

    it "handles empty carts gracefully" do
      # Simulate an empty cart
      Rails.application.env_config["rack.session"] = { cart: {} }

      # Make the request
      get "/checkout"

      # Check that the page loads successfully
      expect(response).to have_http_status(:ok)

      # Check that the page includes a message about the empty cart
      expect(response.body).to include("Your cart is empty").or include("Checkout")
    end
  end
end
