class CreateJobSkillConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :job_skill_connections do |t|
      t.references :job
      t.references :job_skill

      t.integer :importance

      t.timestamps
    end
  end
end
