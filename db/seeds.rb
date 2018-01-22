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
    raise '
      connect between 1 & 10 skills to each job please.
      i would also like a random importance number to be set on the connection.
      please make it efficient, im a busy man ya know
    '
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
