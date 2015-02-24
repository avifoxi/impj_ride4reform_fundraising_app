FactoryGirl.define do
  factory :mailing_address do
  	line_1 Faker::Address.street_address
		line_2 Faker::Address.secondary_address
		city Faker::Address.city
		state Faker::Address.state
		zip '12345'

		trait :donor do 
			association :user, factory: [:user, :donor]
		end

		trait :second do 
			line_1 'second line second'
			line_2 'second line second'
			city 'second city'
			state 'second state'
			zip '12345'
		end

  end
end