require 'bulk_insert'
require 'csv'

class Seeder

  SEED_MODELS = [User, Job, JobSkill]

  def initialize;end

  def import_csvs
    SEED_MODELS.each do |klass|

      klass.bulk_insert do |worker|
        csv_data(klass).each do |row|
          worker.add(row)
        end

        worker.save!
      end
    end
  end

  def connect_job_skills
    # It looks like you've used a bulk_insert gem, but in lieu of using gem's 
    # I'll just do this by hand to show you how and why we sould do this. 
    # The idea is that inserting into a database in 
    # bulk is MUCH faster than doing the operations 1 at a time!
    #   Instructions:
    #   connect between 1 & 10 skills to each job please.
    #   i would also like a random importance number to be set on the connection.
    #   please make it efficient, im a busy man ya know
    # 
    all_jobs = Job.all # Load all of the jobs
    all_skills = JobSkill.all 
    cmds = [] # Array of sql commands we will execute to populate our database with job/skill relations.
    config = Rails.configuration.database_configuration
    database = config[Rails.env]["database"]

    all_jobs.each do |job|
      skill_qty = Random.rand(10) + 1 # Random number of skills to attach to the job
      skill_ids = [] # Collection of skill id's - used so we don't duplicate skills.
      for i in 0..skill_qty
        random_skill = Random.rand(all_skills.length + 1)
        skill_ids << random_skill unless skill_ids.include?(random_skill) # Duplication check
      end # i in 0...
      skill_ids.each do |s|
        stmnt = "insert into job_skill_connections(job_id, job_skill_id, importance, created_at, updated_at) values (#{job.id}, #{s}, #{ Random.rand(10) +1 }, '#{Time.now}', '#{Time.now}')"
        cmds << stmnt
      end
    end # all_jobs.each... 

    db = SQLite3::Database.open(database)
    db.results_as_hash = true

    # This is the bulk execution
    db.execute("begin")
    cmds.each do |stmnt|
      db.execute(stmnt)
    end # cmds.each...
    db.execute("commit")

  end

  private

  def csv_data(klass)
    CSV.open(
      File.join(Rails.root, 'db/data', "#{klass.name.downcase.pluralize}.csv"),
      headers: true
    )
  end

end

seedy = Seeder.new
seedy.import_csvs
seedy.connect_job_skills