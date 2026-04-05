require "test_helper"

class External::ProfileControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get external_profile_path
    assert_response :success
  end
end
