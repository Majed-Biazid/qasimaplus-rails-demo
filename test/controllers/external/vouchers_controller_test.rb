require "test_helper"

class External::VouchersControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get external_vouchers_path
    assert_response :success
  end

  test "show renders voucher detail" do
    get external_voucher_path(orders(:starbucks_voucher))
    assert_response :success
  end

  test "show with invalid id returns 404" do
    get external_voucher_path(id: 99999)
    assert_response :not_found
  end
end
