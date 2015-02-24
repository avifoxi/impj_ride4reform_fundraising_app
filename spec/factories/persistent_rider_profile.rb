FactoryGirl.define do
  factory :persistent_rider_profile do
  	bio 'test bio soo neat'
  	birthdate  Date.new(1995-02-24)
  	primary_phone Faker::PhoneNumber.phone_number
  end
end