RideYear.create(registration_fee: 600, min_fundraising_goal: 2200, year: 2014, ride_start_date: "2014-03-15", ride_end_date: "2014-03-20")

RideYear.create(registration_fee: 650, min_fundraising_goal: 2500, year: 2015, ride_start_date: "2015-03-16", ride_end_date: "2015-03-21").set_as_current

mickey = User.create(first_name: 'mickey', last_name: 'rosen', email: 'foo@foo.com')
avi = User.create(first_name: 'avi', last_name: 'frosen', email: 'foo@bar.com')

ryr = mickey.rider_year_registrations.create(goal: 2500, agree_to_terms: true, ride_option: 'Original Track')

r = avi.receipts.create(amount: 50)

DonationSpec.create(note_to_rider: "hiya dad, ride that there bike", rider_year_registration: ryr, receipt: r)

