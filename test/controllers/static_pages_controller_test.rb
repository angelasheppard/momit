require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

  test "should get code-of-conduct" do
    get static_pages_code-of-conduct_url
    assert_response :success
  end

end
