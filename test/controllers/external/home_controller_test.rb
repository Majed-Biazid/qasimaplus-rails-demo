require "test_helper"

class External::HomeControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get external_home_path
    assert_response :success
  end

  test "root redirects to home" do
    get "/external"
    assert_response :success
  end
end
