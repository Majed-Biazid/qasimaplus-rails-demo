class Job < ApplicationRecord
  STATUSES   = %w[pending running done failed].freeze
  PRIORITIES = %w[high medium low].freeze

  validates :title,    presence: true
  validates :status,   inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }

  scope :recent, -> { order(created_at: :desc) }
end
