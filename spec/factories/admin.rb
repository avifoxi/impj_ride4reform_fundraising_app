FactoryGirl.define do
  factory :admin do
  	username Faker::Internet.user_name
  	password Faker::Internet.password
  	email Faker::Internet.email


  	trait :fresh do 
			username Faker::Internet.user_name
	  	password Faker::Internet.password
	  	email Faker::Internet.email
	  end
  end
end