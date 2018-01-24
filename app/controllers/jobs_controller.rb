class JobsController < ApplicationController

  before_action do
    set_cache_key(Job)
  end

  def index
    @jobs = []
    # Handle a search.
    search_p = search_params # Initialize search_p so we don't have to keep calling search_params.
    if search_p['title'] || search_p['description']
      @jobs = []
      @jobs += search_job(search_params['title'], 'title') if search_p['title']
      @jobs += search_job(search_params['description'], 'description') if search_p['description']
      @jobs.uniq! # Don't return duplicate jobs.
    else
      @jobs = Rails.cache.fetch(@cache_key) do 
        rebuild_cache(@cache_key, Job)
      end
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

    # A fuzzier search based on job title and description words.
    # Returns an array of jobs with attributes who's terms match the search_words.
    # This could be improved by looking for the 'distance between' the search terms
    # and the Job attributes's terms, but that would require some more time consuming/in depth algorithms.
    def search_job(search_words, attribute)
      jobs = [] # Array of jobs matching search words to return.
      # As building the attribute_keywords is fairly expensive and slow, cache it.
      keywords = Rails.cache.fetch("#{attribute}_keywords".to_sym) do 
        build_keywords(attribute)
      end
      search_words.split(' ').each do |w|
        if keywords.has_key?(w.downcase.to_sym)
          keywords[w.downcase.to_sym].each do |job_id|
            jobs << Job.find(job_id)
          end
        end
      end
      jobs
    end

    # Builds a hash with keys of Job title or description terms, and values of job ids (memoization!).
    def build_keywords(attribute)
      keywords = {}
      Job.all.each do |job|
        job.send(attribute).split(' ').each do |word|
          if keywords.has_key?(word.downcase.to_sym)
            keywords[word.downcase.to_sym] << job.id
          else
            keywords[word.downcase.to_sym] = [job.id]
          end
        end
      end
      keywords
    end

end
