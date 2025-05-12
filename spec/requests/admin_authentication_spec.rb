require 'rails_helper'

RSpec.describe "Admin Authentication", type: :request do
  let(:admin) { User.create(email: "admin@example.com", password: "password", admin: true) }

  it "redirects unauthenticated user from rails_admin" do
    get '/admin'
    expect(response).to redirect_to(new_user_session_path)
  end

  it "allows admin to login and access dashboard" do
    # Simulate login
    post user_session_path, params: {
      user: {
        email: admin.email,
        password: 'password'
      }
    }

    follow_redirect!

    get '/admin'
    expect(response.body).to include("Site Administration")
  end
end
