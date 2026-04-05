class Product < ApplicationRecord
  CATEGORIES = %w[Retail F&B Electronics Services Grocery Entertainment].freeze

  validates :name,     presence: true
  validates :price,    numericality: { greater_than: 0 }
  validates :category, inclusion: { in: CATEGORIES }

  scope :in_stock,    -> { where(in_stock: true) }
  scope :by_category, ->(cat) { where(category: cat) }

  def location = description
  def merchant_type = category
end
