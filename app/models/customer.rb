class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy

  PLANS = %w[free starter pro enterprise].freeze

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :plan,  inclusion: { in: PLANS }

  def initials
    name.split.first(2).map { |w| w[0] }.join.upcase
  end

  def total_spent
    orders.sum(:amount)
  end

  def phone
    company
  end

  def voucher_count
    orders.count
  end
end
