module External
  class BaseController < ApplicationController
    layout "external"

    inertia_share do
      consumer = Customer.first
      {
        flash: flash.to_h,
        auth: {
          user: consumer ? {
            id:           consumer.id,
            name:         consumer.name,
            email:        consumer.email,
            phone:        consumer.phone,
            initials:     consumer.initials,
            member_since: consumer.joined_on&.strftime("%B %Y"),
            voucher_count: consumer.voucher_count,
          } : nil,
        },
      }
    end

    private

    def current_consumer
      @current_consumer ||= Customer.first
    end

    def serialize_voucher(order)
      {
        id:            order.id,
        merchant_name: order.merchant_name,
        amount:        order.amount.to_f,
        status:        order.display_status,
        order_id:      format("VCH-%06d", order.id),
        placed_on:     order.placed_on&.iso8601,
        date_display:  order.placed_on&.strftime("%b %d, %Y"),
        time_display:  order.created_at&.strftime("%I:%M %p"),
      }
    end

    def serialize_voucher_detail(order)
      merchant = Product.find_by(name: order.product_name)
      serialize_voucher(order).merge(
        location:       merchant&.location || "Riyadh, Saudi Arabia",
        merchant_type:  merchant&.merchant_type || "Retail",
        payment_method: "Visa •••• 4242",
        consumer_name:  current_consumer&.name,
        consumer_email: current_consumer&.email,
        tax_amount:     order.tax_amount.to_f,
        pre_tax_amount: order.pre_tax_amount.to_f,
      )
    end

    def serialize_consumer(consumer)
      {
        id:            consumer.id,
        name:          consumer.name,
        email:         consumer.email,
        phone:         consumer.phone,
        initials:      consumer.initials,
        plan:          consumer.plan,
        joined_on:     consumer.joined_on&.iso8601,
        member_since:  consumer.joined_on&.strftime("%B %Y"),
        total_spent:   consumer.total_spent.to_f,
        voucher_count: consumer.voucher_count,
      }
    end
  end
end
