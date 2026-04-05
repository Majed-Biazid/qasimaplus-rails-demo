class Job < ApplicationRecord
  STATUSES   = %w[pending running done failed].freeze
  PRIORITIES = %w[high medium low].freeze

  validates :title,    presence: true
  validates :status,   inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }

  scope :recent, -> { order(created_at: :desc) }

  after_create_commit  :broadcast_new,    if: -> { ActionCable.server.config.cable.present? rescue false }
  after_update_commit  :broadcast_update,  if: -> { ActionCable.server.config.cable.present? rescue false }
  after_destroy_commit :broadcast_remove,  if: -> { ActionCable.server.config.cable.present? rescue false }

  private

  def broadcast_new
    broadcast_prepend_to "jobs", target: "job_list",
      partial: "jobs/job", locals: { job: self }
    broadcast_replace_to "jobs", target: "stats_row",
      partial: "dashboard/stats_row"
  end

  def broadcast_update
    broadcast_replace_to "jobs", target: dom_id(self),
      partial: "jobs/job", locals: { job: self }
    broadcast_replace_to "jobs", target: "stats_row",
      partial: "dashboard/stats_row"
  end

  def broadcast_remove
    broadcast_remove_to "jobs", target: dom_id(self)
    broadcast_replace_to "jobs", target: "stats_row",
      partial: "dashboard/stats_row"
  end
end
