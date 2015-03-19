DOING

prp show page 
	- allow current_user == prp to edit content

donation model --
	call back after fee_is_processed to update rider.raised
	also after deletion or change, update rider.raised 
	.... 
		architecture --- 
			although it hits the db more... i think rider.raised should be dynamically gen'd for accuracy and ease of maintenance 
			for now -- quick fix in donations controller

DONE
prp show page 
	- show all donations on prp 
		- add donations to ryr model
	- gauge and percent of progress, vizualization
		- add bower gem to tie js to ruby env
		- d3 / c3




TODO 

root index page
	- make anon buttons actually do something...

fix i element scoping css 

review forms -- 
	- move all shared html to partials, ensure we render from partials rather than custom html in each form. => revise older work to call partials as the newer forms do now, and test

WHAT IF - 
	- user stops registration midway, before creating prp -- then what ?