class MatchedJobsController < ApplicationController

  def index
    @matched_jobs = Job.all.map do |j|
      UserJobMatch.new(user, j).match
    end.sort{ |a, b| b.match <=> a.match }
  end

  private

  def user
    @user ||= User.find(params.require(:user_id))
  end

end
