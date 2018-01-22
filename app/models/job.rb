class Job < ApplicationRecord

  has_many :job_skill_connections, dependent: :destroy
  has_many :job_skills, through: :job_skill_connections

end
