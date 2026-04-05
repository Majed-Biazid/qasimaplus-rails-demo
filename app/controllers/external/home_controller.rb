module External
  class HomeController < BaseController
    def index
      consumer = current_consumer
      vouchers = consumer.orders.recent.limit(5)

      render inertia: "External/Home/Index", props: {
        consumer:        serialize_consumer(consumer),
        recent_vouchers: vouchers.map { |v| serialize_voucher(v) },
        summary: {
          total_spent:   consumer.total_spent.to_f,
          voucher_count: consumer.voucher_count,
        },
      }
    end
  end
end
