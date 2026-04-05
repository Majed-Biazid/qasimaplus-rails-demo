class Dashboard::StatCardComponent < ViewComponent::Base
  COLORS = {
    blue:   { border: "border-blue-500",   value: "text-blue-600",   bg: "bg-blue-50"   },
    green:  { border: "border-green-500",  value: "text-green-600",  bg: "bg-green-50"  },
    yellow: { border: "border-yellow-500", value: "text-yellow-600", bg: "bg-yellow-50" },
    red:    { border: "border-red-500",    value: "text-red-600",    bg: "bg-red-50"    },
  }.freeze

  def initialize(title:, value:, icon:, color: :blue, subtitle: nil)
    @title    = title
    @value    = value
    @icon     = icon
    @color    = color.to_sym
    @subtitle = subtitle
  end

  def theme = COLORS.fetch(@color, COLORS[:blue])
end
