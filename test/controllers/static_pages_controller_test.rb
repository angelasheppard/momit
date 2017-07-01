require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "MOMiT"
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", @base_title
  end

  test "should get code_of_conduct" do
    get code_of_conduct_url
    assert_response :success
    assert_select "title", "Code of Conduct | #{@base_title}"
  end

  test "should get guild_policies" do
    get guild_policies_url
    assert_response :success
    assert_select "title", "Guild Policies | #{@base_title}"
  end
end
