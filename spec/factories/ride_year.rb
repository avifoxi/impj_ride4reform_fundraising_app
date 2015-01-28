FactoryGirl.define do
  factory :ride_year do

		trait :old do
	    registration_fee 600
			min_fundraising_goal 2200
			year 2014
	  end

    trait :current do
	    registration_fee 650
			min_fundraising_goal 2500
			year 2015
	  end

  end
end