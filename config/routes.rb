Rails.application.routes.draw do

  namespace :admin do
    resources :jobs, except: :create
    resources :users, except: :create
  end

  resources :jobs, only: [:index, :show]
  
  resources :users, only: [] do
    resources :matched_jobs, only: :index
  end

end
