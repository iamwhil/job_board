class UsersController < ApplicationController

  before_action do
    set_cache_key(User)
  end

  def index
    @users = Rails.cache.fetch(@cache_key) do 
      rebuild_cache(@cache_key, User)
    end
  end

  def show
    @user = User.find(params.require(:id))
  end

end