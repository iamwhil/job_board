class JobsController < ApplicationController

  before_action do
    set_cache_key(Job)
  end

  def index
    @jobs = Rails.cache.fetch(@cache_key) do 
      rebuild_cache(@cache_key, Job)
    end
    # handle a search.
    @jobs.select!{ |j| j.title == search_params['title'] } if search_params['title']
    @jobs.select!{ |j| j.description == search_params['description'] } if search_params['description']
  end

  def show
    @job = Job.find(params.require(:id))
  end

  private

  def search_params
    params.delete(:page) # Remove :page so we don't see unpermitted parameter warnings.
    params.permit(:title, :description)
  end

end
