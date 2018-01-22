class UserJobSkillDeterminer

  def initialize(user)
    @user = user
  end

  def call
    JobSkill.all.sample(Random.rand(1..5))
  end

end
