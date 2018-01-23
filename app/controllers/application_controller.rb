require 'dalli'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # Items_per_page returns the number of items returned for pagination.
  # This should be the same number as the memcached.rb initializer.
  def items_per_page
  	10
  end

  # If the given cache entry is not found, we rebuilt it if the request if valid.
  def rebuild_cache(cache_key, klass)
    page = cache_key.slice(cache_key.index(/\d/)..cache_key.length).to_i
    klass.all.order(:id)[(page * items_per_page)..(page * items_per_page + items_per_page)].to_a
  end

  # Looks at the :page parameter passed in, and returns the cache_key for that page's data.
  def set_cache_key(klass)
    @cache_key = params[:page] ? "#{klass.to_s.pluralize.downcase}_page#{params[:page]}" : "jobs_page1"
  end

end
