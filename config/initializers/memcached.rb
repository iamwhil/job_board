# This initializer is utilized to create the cached values for 
# Jobs, Users and the Admin namespace.
# When we recall them in the controllers we will use .fetch as the memcached
# server is not persistent.  If it gets reset the values will be gone.
# We will be pulling the same user and job information from the database for
# the admin and the normal side (for now).

models = [User, Job]
items_per_page = 10
models.each do |klass|
	i = 1
	set = []
	klass.all.order(:id).each do |item|
		set << item
		if i % items_per_page == 0 
			cache_key = "#{klass.to_s.pluralize.downcase}_page#{((i / items_per_page)).to_i}".to_sym
			Rails.cache.write(cache_key, set)
			set = []
		end
		i += 1
	end
end