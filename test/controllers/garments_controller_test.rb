require "test_helper"

class GarmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get garments_index_url
    assert_response :success
  end

  test "should get show" do
    get garments_show_url
    assert_response :success
  end

  test "should get new" do
    get garments_new_url
    assert_response :success
  end

  test "should get create" do
    get garments_create_url
    assert_response :success
  end

  test "should get edit" do
    get garments_edit_url
    assert_response :success
  end

  test "should get update" do
    get garments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get garments_destroy_url
    assert_response :success
  end
end
