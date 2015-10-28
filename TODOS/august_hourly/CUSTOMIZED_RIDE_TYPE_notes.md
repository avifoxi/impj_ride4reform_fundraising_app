Custom Ride Type ---

10 -- round to 10 hrs

start @ 8:30pm

remove liability text

Case in point -- 
Rabbinic shorter ride 

TODOS => 

	- build model (v1 is done)
	- add creation form to ride year in admin portal

 	- determine how custom option is associated with RYR


functionally -- this should be One to Many on Ride Year

	a ride year may have many custom_ride_types
	a custom_ride_type may only have 1 ride_year

	slightly more work for admin-- less pain in butt for me

Custom Ride Type (pseudo code)
	belongs_to :ride_year

	attrs => 
		- display_name < String >
		- description < text >
		- liability text < text > 
		- start_date < date >
		- end_date < date >
		- discount_code < string -- not encrypted bc really not necessary >
		- registration_cutoff < date >
		- cost < int > 
		- ride_year_id < references >

end

ALSO => 
	this affects rider_year_registration 
	RIDE_OPTIONS must have 'Custom' option 
	and then this references 
