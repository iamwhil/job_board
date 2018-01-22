class JobsController < ApplicationController

  def index
    @jobs = Job.all.to_a
    @jobs.select!{ |j| j.title == search_params['title'] } if search_params['title']
    @jobs.select!{ |j| j.description == search_params['description'] } if search_params['description']
  end

  def show
    @job = Job.find(params.require(:id))
  end

  private

  def search_params
    params.permit(:title, :description)
  end

end
