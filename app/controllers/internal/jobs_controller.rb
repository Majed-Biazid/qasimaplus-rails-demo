module Internal
  class JobsController < BaseController
    before_action :set_job, only: %i[update destroy]

    def index
      @jobs = Job.recent
      @job  = Job.new
    end

    def create
      @job = Job.new(job_params)
      if @job.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.prepend("job_list", partial: "jobs/job", locals: { job: @job }),
              turbo_stream.replace("new_job_form", partial: "jobs/form", locals: { job: Job.new }),
              turbo_stream.replace("stats_row", partial: "dashboard/stats_row"),
            ]
          end
          format.html { redirect_to internal_jobs_path }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("new_job_form", partial: "jobs/form", locals: { job: @job }), status: :unprocessable_entity }
          format.html { redirect_to internal_jobs_path, alert: @job.errors.full_messages.join(", ") }
        end
      end
    end

    def update
      if @job.update(status: params[:status])
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace(@job, partial: "jobs/job", locals: { job: @job }),
              turbo_stream.replace("stats_row", partial: "dashboard/stats_row"),
            ]
          end
          format.html { redirect_to internal_jobs_path }
        end
      else
        head :unprocessable_entity
      end
    end

    def destroy
      @job.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(@job),
            turbo_stream.replace("stats_row", partial: "dashboard/stats_row"),
          ]
        end
        format.html { redirect_to internal_jobs_path }
      end
    end

    private

    def set_job
      @job = Job.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:title, :status, :priority)
    end
  end
end
