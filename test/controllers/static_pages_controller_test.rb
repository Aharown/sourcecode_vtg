require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get shipping" do
    get static_pages_shipping_url
    assert_response :success
  end

  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
  end

  test "should get terms" do
    get static_pages_terms_url
    assert_response :success
  end
end
