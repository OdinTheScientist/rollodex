require "test_helper"

class TechniquesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get techniques_index_url
    assert_response :success
  end

  test "should get show" do
    get techniques_show_url
    assert_response :success
  end

  test "should get new" do
    get techniques_new_url
    assert_response :success
  end

  test "should get edit" do
    get techniques_edit_url
    assert_response :success
  end
end
