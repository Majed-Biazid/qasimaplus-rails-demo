class Order < ApplicationRecord
  belongs_to :customer

  STATUSES = %w[paid pending refunded].freeze

  validates :product_name, presence: true
  validates :amount,       presence: true, numericality: { greater_than: 0 }
  validates :status,       inclusion: { in: STATUSES }

  scope :recent, -> { order(placed_on: :desc) }

  def merchant_name = product_name

  def display_status
    case status
    when "paid" then "completed"
    else status
    end
  end

  def tax_amount
    (amount * 0.15).round(2)
  end

  def pre_tax_amount
    (amount - tax_amount).round(2)
  end
end
