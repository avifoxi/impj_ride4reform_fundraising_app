DOING

prp => mailing address crud for user ui
	links are up, but not functional


TODO


prp show page 
	- allow current_user == prp to edit content
`

Build out admin functions -- allow admin to manually create / edit / destroy users and associated tables, admin export of data, manually add donations for checks received

allow admin to send batch emails

rider/:id/donations --- table with tools for rider to access + maintain relationships with 

multi-year riders-- integrating this to sign-up path, and adding link for rider to register for new ride from their prp page

ryr_registration_payment -- 
	add cc_info validations as in donation pyament 


very importatn rake task:
	rake assets:precompile RAILS_ENV=production

images -- size limits on prp image submission

review forms -- 
	- move all shared html to partials, ensure we render from partials rather than custom html in each form. => revise older work to call partials as the newer forms do now, and test

WHAT IF - 
	- user stops registration midway, before creating prp -- then what ?

QUESTIONS FOR DAD --
	- give donor ability to cancel their own donation? (what does kickstarter do?)
	- cancellations ? refund policy ? if a rider cancels, policy to refund the donors ? 
		-- and what does this mean for deleting a profile? we shoudl perhaps have an 'active' field in prp, and only show prp if 'active'

DONE

mailgun -- need acc't for dad directly 

Build the email engine, that will mail users after they register, riders when they receive a new donation, and 

Donations tests

prp show page 
	- show all donations on prp 
		- add donations to ryr model
	- gauge and percent of progress, vizualization
		- add bower gem to tie js to ruby env
		- d3 / c3

donation model --
	architecture --- 
		although it hits the db more... i think rider.raised should be dynamically gen'd for accuracy and ease of maintenance 

root index page
	- make anon buttons actually do something...

in seeds --> create receipts on successful donation


