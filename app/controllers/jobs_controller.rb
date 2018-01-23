class JobsController < ApplicationController

  before_action :set_cache_key

  def index
    @jobs = Rails.cache.fetch(@cache_key) do 
      rebuild_cache(@cache_key)
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

  # Looks at the :page parameter passed in, and returns the cache_key for that page's data.
  def set_cache_key
    @cache_key = params[:page] ? "jobs_page#{params[:page]}" : "jobs_page1"
  end

  # If the given cache entry is not found, we rebuilt it if the request if valid.
  def rebuild_cache(cache_key)
    page = cache_key.slice(cache_key.index(/\d/)..cache_key.length).to_i
    Job.all.order(:id)[(page * items_per_page)..(page * items_per_page + items_per_page)].to_a
  end

end
