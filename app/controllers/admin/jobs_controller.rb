module Admin
  class JobsController < ApplicationController

    before_action only: [:index] do 
      set_cache_key(Job)
    end

    def index
      @jobs = Rails.cache.fetch(@cache_key) do 
        rebuild_cache(@cache_key, Job)
      end
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
