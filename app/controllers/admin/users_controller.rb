module Admin
  class UsersController < ApplicationController

    before_action only: [:index] do 
      set_cache_key(User)
    end

    def index
      @users = Rails.cache.fetch(@cache_key) do 
        rebuild_cache(@cache_key, User)
      end
    end

    def create
      @user = User.create(user_params)
    end

    def show
      @user = User.find(params.require(:id))
    end

    def update
      @user = User.find(params.require(:id))
      @user.update(user_params)
    end

    def destroy
      @user = User.find(params.require(:id)).destroy
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :gender)
    end

  end
end
