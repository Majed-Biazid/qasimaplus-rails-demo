require "test_helper"

class RoutesTest < ActionDispatch::IntegrationTest
  test "root redirects to internal" do
    get "/"
    assert_redirected_to "/internal"
  end

  test "all internal routes return 200" do
    [internal_dashboard_path, internal_jobs_path, internal_customers_path].each do |path|
      get path
      assert_response :success, "Expected 200 for #{path}, got #{response.status}"
    end
  end

  test "all external routes return 200" do
    [external_home_path, external_vouchers_path, external_profile_path].each do |path|
      get path
      assert_response :success, "Expected 200 for #{path}, got #{response.status}"
    end
  end

  test "health check works" do
    get rails_health_check_path
    assert_response :success
  end

  test "missing records return 404" do
    get internal_customer_path(id: 99999)
    assert_response :not_found

    get external_voucher_path(id: 99999)
    assert_response :not_found
  end
end
