require 'rails_helper'

RSpec.describe "Cart", type: :request do
  describe "GET /cart" do
    it "renders the cart page successfully" do
      get "/cart"
      expect(response).to have_http_status(:ok)
    end
  end
end
