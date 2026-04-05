require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  test "valid customer" do
    customer = Customer.new(name: "Test User", email: "test@unique.com", plan: "free", company: "+966 50 000 0000")
    assert customer.valid?
  end

  test "requires name" do
    customer = Customer.new(name: "", email: "a@b.com", plan: "free")
    assert_not customer.valid?
  end

  test "requires unique email" do
    customer = Customer.new(name: "Dup", email: customers(:majed).email, plan: "free")
    assert_not customer.valid?
  end

  test "validates plan inclusion" do
    customer = Customer.new(name: "X", email: "x@y.com", plan: "invalid")
    assert_not customer.valid?
  end

  test "initials returns first letters" do
    assert_equal "MB", customers(:majed).initials
    assert_equal "SA", customers(:sara).initials
  end

  test "total_spent sums order amounts" do
    total = customers(:majed).total_spent
    assert_equal customers(:majed).orders.sum(:amount), total
  end

  test "phone returns company field" do
    assert_equal customers(:majed).company, customers(:majed).phone
  end

  test "voucher_count returns orders count" do
    assert_equal customers(:majed).orders.count, customers(:majed).voucher_count
  end
end
