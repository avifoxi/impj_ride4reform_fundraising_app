FactoryGirl.define do
  factory :ride_year do

  	registration_fee 650
		min_fundraising_goal 2500
		year 2015
		

    trait :current do
	    first_name "Rider"
			last_name "Test"
			email "rider@test.com"
	  end

	  # trait :donor do
	  #   first_name "Donor"
			# last_name "Test"
			# email "donor@test.com"
	  # end

  end
end