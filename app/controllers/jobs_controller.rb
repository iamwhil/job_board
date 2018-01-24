class JobsController < ApplicationController

  before_action do
    set_cache_key(Job)
  end

  def index
    @jobs = Rails.cache.fetch(@cache_key) do 
      rebuild_cache(@cache_key, Job)
    end
    # handle a search.
    if search_params['title'] || search_params['description']
      @jobs = search_job_titles(search_params['title'])
      #@jobs.select!{ |j| j.title == search_params['title'] } if search_params['title']
      #@jobs.select!{ |j| j.description == search_params['description'] } if search_params['description']
    end
  end

  def show
    @job = Job.find(params.require(:id))
  end

  private

  # Returns the parameters for the search.
  def search_params
    params.delete(:page) # Remove :page so we don't see unpermitted parameter warnings.
    params.permit(:title, :description)
  end

  # A fuzzier search based on job title words.
  # Returns an array of jobs with titles who's terms match the search_words.
  # This could be improved by looking for the 'distance between' the search terms
  # and the Job title's terms, but that would require some more time consuming/in depth algorithms.
  def search_job_titles(search_words)
    jobs = [] # Array of jobs matching search words to return.
    # As building the title_keywords is fairly expensive and slow, cache it.
    title_keywords = Rails.cache.fetch(:title_keywords) do 
      build_title_keywords
    end
    search_words.split(' ').each do |w|
      if title_keywords.has_key?(w.downcase.to_sym)
        title_keywords[w.downcase.to_sym].each do |job_id|
          jobs << Job.find(job_id)
        end
      end
    end
    jobs
  end

  # Builds a hash with keys of Job title terms, and values of job ids (memoization!).
  def build_title_keywords
    title_keywords = {}
    Job.all.each do |job|
      job.title.split(' ').each do |word|
        if title_keywords.has_key?(word.downcase.to_sym)
          title_keywords[word.downcase.to_sym] << job.id
        else
          title_keywords[word.downcase.to_sym] = [job.id]
        end
      end
    end
    title_keywords
  end

end
