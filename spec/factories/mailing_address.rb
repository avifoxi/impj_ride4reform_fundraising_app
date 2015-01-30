FactoryGirl.define do
  factory :mailing_address do
  	line_1 Faker::Address.street_address
		line_2 Faker::Address.secondary_address
		city Faker::Address.city
		state Faker::Address.state
		zip Faker::Address.zip.to_i

		trait :donor do 
			association :user, factory: [:user, :donor]
		end

  end
end