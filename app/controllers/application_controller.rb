require 'dalli'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # Items_per_page returns the number of items returned for pagination.
  # This should be the same number as the memcached.rb initializer.
  def items_per_page
  	10
  end

end
