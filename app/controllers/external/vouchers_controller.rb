module External
  class VouchersController < BaseController
    def index
      consumer = current_consumer
      vouchers = consumer.orders.recent

      render inertia: "External/Vouchers/Index", props: {
        vouchers:      vouchers.map { |v| serialize_voucher(v) },
        consumer_name: consumer.name,
      }
    end

    def show
      voucher = Order.find(params[:id])

      render inertia: "External/Vouchers/Show", props: {
        voucher: serialize_voucher_detail(voucher),
      }
    end
  end
end
