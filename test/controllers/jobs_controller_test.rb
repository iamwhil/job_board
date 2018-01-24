# To keep things simple, I have copied the seeded development 
# database to the test database.
require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest

	# Should return the index and the JSON response should include 10 jobs.
	test "should return the index" do 
		get jobs_path, params: {}
		assert_response :success
		assert_equal 10, JSON.parse(response.body)['jobs'].length
		assert_equal 1, JSON.parse(response.body)['jobs'][0]['id']
	end

	# Should return the 7th page of responses for the index.  First job should be Job.id = 61.
	test "should return the index at page 7" do 
		get jobs_path, params: { page: 7 }
		assert_response :success
		assert_equal 10, JSON.parse(response.body)['jobs'].length
		assert_equal 61, JSON.parse(response.body)['jobs'][0]['id']
	end

	test "should return the search results for titles containing 'programming'" do 
		get jobs_path, params: { title: 'programmer' } 
		assert_response :success
		assert JSON.parse(response.body)['jobs'][0]['title'].to_s.downcase.index("programmer")
	end

	test "should return the search results for descriptions containing 'ipsum'" do 
		get jobs_path, params: { description: 'ipsum' } 
		assert_response :success
		assert JSON.parse(response.body)['jobs'][0]['description'].to_s.downcase.index("ipsum")
	end 

	test "should return the search for description 'ipsum' filtered to require job skill 'legal issues'" do 
		get jobs_path, params: { filter: 'Legal Issues' }
		assert_response :success
		assert Job.find(JSON.parse(response.body)['jobs'][0]['id']).job_skills.include?(JobSkill.find_by(title: 'Legal Issues'))
	end

end
