FactoryGirl.define do
  factory :user do

  	password Faker::Internet.password
  	title 'None'
  	first_name "Fresh User"
		last_name "W/out Associations"
		email "fresh@test.com"	


    trait :rider do
	    first_name "Rider"
			last_name "Test"
			email "rider@test.com"	
	  end

	  trait :donor do
	    first_name "Donor"
			last_name "Test"
			email "donor@test.com"
			
	  end

  end
end

