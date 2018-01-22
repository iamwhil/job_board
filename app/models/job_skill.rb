class JobSkill < ApplicationRecord

  has_many :job_skill_connections, dependent: :destroy
  has_many :jobs, through: :job_skill_connections

end
