class AddIndexToJobSkillsTitle < ActiveRecord::Migration[5.1]
  def change
  	add_index :job_skills, :title
  end
end
