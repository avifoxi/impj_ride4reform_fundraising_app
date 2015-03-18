require 'faker'

# case Rails.env
# when "development"
	Admin.create(username: 'AviAdmin', email:'admin@admin.com', password: 'adminpass')

	RideYear.create(registration_fee: 600, registration_fee_early: 550, min_fundraising_goal: 2200, year: 2014, ride_start_date: "2014-03-15", ride_end_date: "2014-03-20", early_bird_cutoff: "2014-01-15")

	RideYear.create(registration_fee: 650, registration_fee_early: 600, min_fundraising_goal: 2500, year: 2015, ride_start_date: "2015-03-16", ride_end_date: "2015-03-21", early_bird_cutoff: "2015-01-15")

	RideYear.last.set_as_current

  goals = (2500..10000).to_a

  User.create(first_name: "Avi", last_name: "Rider", email: "a@a.com", password: 'password', title: User::TITLES.sample)
  avi = RiderYearRegistration.create(
      user: User.first,
      goal: goals.sample,
      agree_to_terms: true,
      ride_option: RiderYearRegistration::RIDE_OPTIONS.sample
    )
  avi.mailing_addresses.create(
        line_1: Faker::Address.street_address,
        city: Faker::Address.city,
        zip: Faker::Address.zip_code,
        state: Faker::Address.state)
  prp = avi.user.build_persistent_rider_profile
    unless prp.update_attributes(
          primary_phone: '1234567890',
          birthdate: Faker::Date.between(20.years.ago, 60.years.ago).to_s,
          bio: Faker::Hacker.say_something_smart 
          # ,user: user
    )
      p 'errors'
      p "#{prp.errors.inspect}"
    end

	users = []
	50.times do 
    users << User.create(title: User::TITLES.sample, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: Faker::Internet.password)
  end

  # create riders with persistent rider profiles, current year registration
  20.times do 
  	user = users.pop
  	rider = RiderYearRegistration.create(
  		user: user,
  		goal: goals.sample,
  		agree_to_terms: true,
  		ride_option: RiderYearRegistration::RIDE_OPTIONS.sample
  	)

    rider.update_attributes(ride_year: RideYear.all.sample)

  	rider.mailing_addresses.create(
  			line_1: Faker::Address.street_address,
  			city: Faker::Address.city,
  			zip: Faker::Address.zip_code,
  			state: Faker::Address.state)

  	prp = rider.user.build_persistent_rider_profile
  	unless prp.update_attributes(
  				primary_phone: '1234567890',
					birthdate: Faker::Date.between(20.years.ago, 60.years.ago).to_s,
					bio: Faker::Hacker.say_something_smart 
					# ,user: user
  	)
  		p 'errors'
  		p "#{prp.errors.inspect}"
  	end
  	
  end

  amounts = (18..800).to_a
  50.times do 
    user = users.sample
    ryr = RiderYearRegistration.all.sample
    don = Donation.create(
      visible_to_public: [true, false].sample,
      note_to_rider: Faker::Hacker.say_something_smart,
      rider_year_registration: ryr,
      user: user,
      amount: amounts.sample,
      fee_is_processed: true
    )
    if don.fee_is_processed
      ryr.raised += don.amount
      ryr.save
    end
  end

# when "production"
# 	Admin.create(username: 'AviAdmin', email:'admin@admin.com', password: 'adminpass')
# 	RideYear.create(registration_fee: 600, registration_fee_early: 550, min_fundraising_goal: 2200, year: 2014, ride_start_date: "2014-03-15", ride_end_date: "2014-03-20", early_bird_cutoff: "2014-01-15")

# 	RideYear.create(registration_fee: 650, registration_fee_early: 600, min_fundraising_goal: 2500, year: 2015, ride_start_date: "2015-03-16", ride_end_date: "2015-03-21", early_bird_cutoff: "2015-01-15")

# 	RideYear.last.set_as_current

# end