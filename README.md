# Job Board

I would like my Job Board API to fulfill the requirements below. Reading through the description should give you an idea of what it supposed to accomplish. Some pieces may be ambiguous or even missing but I value your product/feature decisions (we're a team right?). Think of this exercise not as a way for me to evaluate you but as a way for me to understand your work.

Commit/comment when/how you naturally would and when you're finished submit a pull request so I can check it out. If this takes you longer than 6/7hrs I would say submit what you have because I'll have enough to go off of at that point. The goal isn't necessarily to finish all the tasks in the time given but to do well with the tasks that you do finish. I don't expect full test coverage but I'd like for there to be some amount of effort on the changes you do make.

Any questions feel free to ping me

### Description

I have a job board which people can use to search for jobs as well as an admin section for our employees to make necessary data updates. This is it's mostly functioning API. What makes my job board special is we match people to jobs because we know what skills the jobs have AND the skills people have! We need YOU to help us make some much needed upgrades so we can sell to Microsoft and all get free Office products for life.

### Setup
1. `bundle install`
2. `bundle exec rake db:migrate:reset db:seed`

### Requirements
Fork this repo and make whatever updates necessary to achieve the following tasks:

- Shucks, my seed task doesn't work all the way. Check out the seeds file to find out what it needs.
- Add pagination to jobs#idx, admin/jobs#idx, and users#idx
- jobs#idx kinda sucks for a job search platform. It would be nice if it wasn't so strict. Caching would be nice too.
- Update job#idx to be able to filter by any number of given skills.
- Only allow 'admins' to access my admin namespace.
- In order to match Users to Jobs I'll need Users to be able to set their job skills too.
- admin/matched_jobs#idx isn't the most efficient method nor is UserJobMatch the most well thought out (or actually functioning) match score. What changes would you make given the information we have?
- Our admins would love to get a list of which users match a specific job. That way we can do something with recruiters cause they like that sorta thing.
