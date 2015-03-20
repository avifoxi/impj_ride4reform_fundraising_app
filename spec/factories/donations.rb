# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donation do
    anonymous_to_public true
    note_to_rider "I donate to you for riding your bike"
  	amount 300

  	trait :with_valid_associations do 
	    association :rider_year_registration, factory: [:rider_year_registration, :with_valid_associations]
	    association :receipt, factory: [:receipt, :donation]
  	end
  end
end
