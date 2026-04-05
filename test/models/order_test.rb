require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "valid order" do
    order = Order.new(customer: customers(:majed), product_name: "Test", amount: 10.0, status: "paid", placed_on: Date.today)
    assert order.valid?
  end

  test "requires product_name" do
    order = Order.new(customer: customers(:majed), product_name: "", amount: 10, status: "paid")
    assert_not order.valid?
  end

  test "amount must be positive" do
    order = Order.new(customer: customers(:majed), product_name: "X", amount: -1, status: "paid")
    assert_not order.valid?
  end

  test "validates status inclusion" do
    order = Order.new(customer: customers(:majed), product_name: "X", amount: 10, status: "invalid")
    assert_not order.valid?
  end

  test "merchant_name aliases product_name" do
    assert_equal orders(:starbucks_voucher).product_name, orders(:starbucks_voucher).merchant_name
  end

  test "display_status maps paid to completed" do
    assert_equal "completed", orders(:starbucks_voucher).display_status
    assert_equal "pending", orders(:pending_voucher).display_status
    assert_equal "refunded", orders(:refunded_voucher).display_status
  end

  test "tax_amount is 15% of amount" do
    order = orders(:starbucks_voucher)
    expected = (order.amount * 0.15).round(2)
    assert_equal expected, order.tax_amount
  end

  test "pre_tax_amount is amount minus tax" do
    order = orders(:starbucks_voucher)
    assert_equal (order.amount - order.tax_amount).round(2), order.pre_tax_amount
  end
end
