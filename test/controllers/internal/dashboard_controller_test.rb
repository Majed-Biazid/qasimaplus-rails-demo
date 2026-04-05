require "test_helper"

class Internal::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get internal_dashboard_path
    assert_response :success
    assert_includes response.body, "Admin Dashboard"
  end
end
