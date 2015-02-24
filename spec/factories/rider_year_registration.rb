FactoryGirl.define do
  factory :rider_year_registration do

  	goal 2600
  	ride_option 'Original Track'
  	agree_to_terms true

  	trait :with_valid_associations do
  		association :ride_year, factory: [:ride_year, :current]
  		association :user, factory: [:user, :rider]
		end

  end
end