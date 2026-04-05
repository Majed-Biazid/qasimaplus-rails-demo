require "test_helper"

class Internal::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get internal_customers_path
    assert_response :success
    assert_select "div.ops-page-title", "Consumers"
  end

  test "show renders consumer profile" do
    get internal_customer_path(customers(:majed))
    assert_response :success
    assert_includes response.body, "Majed Biazid"
  end

  test "show with invalid id returns 404" do
    get internal_customer_path(id: 99999)
    assert_response :not_found
  end
end
