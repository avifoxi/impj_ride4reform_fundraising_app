FactoryGirl.define do
  factory :rider_year_registration do

  	goal 2600
  	ride_option 'Riding4Reform- Challenge'
  	agree_to_terms true

  	trait :with_valid_associations do
  		association :ride_year, factory: [:ride_year, :current]
  		association :user, factory: [:user, :rider]
		end

    trait :old do
      # must manually assign to old ride_year after creation, bc of callback in model
      # association :ride_year, factory: [:ride_year, :old]
      association :user, factory: [:user, :rider_two]
    end

  end
end