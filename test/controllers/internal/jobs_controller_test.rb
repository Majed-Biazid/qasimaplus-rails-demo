require "test_helper"

class Internal::JobsControllerTest < ActionDispatch::IntegrationTest
  test "index renders successfully" do
    get internal_jobs_path
    assert_response :success
  end

  test "create with valid params via turbo_stream" do
    assert_difference("Job.count", 1) do
      post internal_jobs_path, params: { job: { title: "New job", priority: "medium", status: "pending" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success
    assert_includes response.body, "turbo-stream"
  end

  test "create with invalid params returns unprocessable" do
    assert_no_difference("Job.count") do
      post internal_jobs_path, params: { job: { title: "", priority: "medium", status: "pending" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :unprocessable_entity
  end

  test "update changes job status via turbo_stream" do
    job = jobs(:pending_job)
    patch internal_job_path(job), params: { status: "running" },
      headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_equal "running", job.reload.status
  end

  test "destroy removes job via turbo_stream" do
    job = jobs(:done_job)
    assert_difference("Job.count", -1) do
      delete internal_job_path(job),
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success
  end
end
