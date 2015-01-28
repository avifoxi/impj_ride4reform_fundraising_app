FactoryGirl.define do
  factory :user do

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

