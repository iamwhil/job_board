# Checking to make sure @jobs is set, else returns an empty array.

if @jobs
	json.jobs @jobs, :id, :title, :description
else
	json.jobs([])
end