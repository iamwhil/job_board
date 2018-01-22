module Admin
  class JobsController < ApplicationController

    def index
      @jobs = Job.all
    end

    def show
      @job = Job.find(params.require(:id))
    end

    def update
      @job = Job.find(params.require(:id))
      @job.update(job_params)
    end

    def destroy
      @job = Job.find(params.require(:id)).destroy
    end

    private

    def job_params
      params.require(:job).permit(:title, :description)
    end

  end
end
