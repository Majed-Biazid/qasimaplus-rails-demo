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
          format.turbo_stream { render turbo_stream: turbo_stream.replace("new_job_form", partial: "jobs/form", locals: { job: Job.new }) }
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
        head :ok
      else
        head :unprocessable_entity
      end
    end

    def destroy
      @job.destroy
      head :ok
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
