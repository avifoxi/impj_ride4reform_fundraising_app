FactoryGirl.define do
  factory :persistent_rider_profile do
  	bio 'test bio soo neat'
  	birthdate  Date.parse('1995-02-24')
  	primary_phone Faker::PhoneNumber.phone_number
  
  	# trait :with_user do
  	# 	association :user, factory: [:user, :rider]
  	# 	# association :rider_year_registrations, factory: :rider_year_registration
  	# 	self.rider_year_registrations << FactoryGirl.create()
  	# end
  end
end