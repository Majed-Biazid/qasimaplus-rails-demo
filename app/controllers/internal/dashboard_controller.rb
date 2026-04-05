module Internal
  class DashboardController < BaseController
    def index
      @jobs = Job.recent
      @voucher_stats = {
        total:    Order.count,
        consumers: Customer.count,
        revenue:  Order.where(status: "paid").sum(:amount),
        pending:  Order.where(status: "pending").count,
      }
      @recent_vouchers = Order.recent.limit(6).includes(:customer)
    end
  end
end
