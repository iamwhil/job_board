class JobSkillConnection < ApplicationRecord

  belongs_to :job
  belongs_to :job_skill

  validates_presence_of :job, :job_skill

  # 1 being least important, 10 being most
  validates_inclusion_of :importance, in: 1..10

end
