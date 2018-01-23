# Check to make sure @users is set, else returns an empty array.
if @users
	json.users @users, :id, :first_name, :last_name, :email, :gender
else
	json.users([])
end