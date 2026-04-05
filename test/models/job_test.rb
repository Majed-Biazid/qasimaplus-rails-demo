require "test_helper"

class JobTest < ActiveSupport::TestCase
  test "valid job" do
    job = Job.new(title: "Test", status: "pending", priority: "high")
    assert job.valid?
  end

  test "requires title" do
    job = Job.new(title: "", status: "pending", priority: "high")
    assert_not job.valid?
    assert_includes job.errors[:title], "can't be blank"
  end

  test "validates status inclusion" do
    job = Job.new(title: "Test", status: "invalid", priority: "high")
    assert_not job.valid?
  end

  test "validates priority inclusion" do
    job = Job.new(title: "Test", status: "pending", priority: "invalid")
    assert_not job.valid?
  end

  test "recent scope returns jobs ordered by created_at desc" do
    old = Job.create!(title: "Old", status: "pending", priority: "low", created_at: 1.hour.ago)
    recent = Job.create!(title: "Recent", status: "pending", priority: "low", created_at: Time.current)
    result = Job.recent
    assert result.index(recent) < result.index(old)
  end
end
