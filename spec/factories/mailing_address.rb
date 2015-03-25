FactoryGirl.define do
  factory :mailing_address do
  	line_1 Faker::Address.street_address
		line_2 Faker::Address.secondary_address
		city Faker::Address.city
		state 'NY'
		zip '11218'

		trait :donor do 
			association :user, factory: [:user, :donor]
		end

		trait :second do 
			line_1 'second line second'
			line_2 'second line second'
			city 'second city'
			state 'CA'
			zip '90035'
		end

  end
end