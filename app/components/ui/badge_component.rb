class Ui::BadgeComponent < ViewComponent::Base
  STYLES = {
    "pending" => "bg-yellow-100 text-yellow-800 border-yellow-200",
    "running" => "bg-blue-100 text-blue-800 border-blue-200",
    "done"    => "bg-green-100 text-green-800 border-green-200",
    "failed"  => "bg-red-100 text-red-800 border-red-200",
    "high"    => "bg-red-50 text-red-700 border-red-200",
    "medium"  => "bg-yellow-50 text-yellow-700 border-yellow-200",
    "low"     => "bg-gray-50 text-gray-600 border-gray-200",
  }.freeze

  def initialize(label:, type: "default")
    @label = label
    @type  = type.to_s
  end

  def css = STYLES.fetch(@type, "bg-gray-100 text-gray-700 border-gray-200")
end
