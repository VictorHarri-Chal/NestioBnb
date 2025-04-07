require "test_helper"

class AccommodationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get accommodation_index_url
    assert_response :success
  end

  test "should get show" do
    get accommodation_show_url
    assert_response :success
  end

  test "should get new" do
    get accommodation_new_url
    assert_response :success
  end

  test "should get create" do
    get accommodation_create_url
    assert_response :success
  end

  test "should get edit" do
    get accommodation_edit_url
    assert_response :success
  end

  test "should get update" do
    get accommodation_update_url
    assert_response :success
  end
end
