class UserJobMatch

  def initialize(user, job)
    @user = user
    @job = job
  end

  def match
    match_score = user_skills.inject(0) do |summ, us|
      if job_skill_ids.include?(us.id)
        summ += 1
      end

      summ
    end

    MatchedJob.new(@job.id, match_score)
  end

  private

  def user_skills
    UserJobSkillDeterminer.new(@user).call
  end

  def job_skill_conns
    @job_skill_conns ||= @job.job_skill_connections
  end

  def job_skill_ids
    job_skill_conns.pluck(:job_skill_id)
  end

end
