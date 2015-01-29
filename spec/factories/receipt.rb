FactoryGirl.define do
  factory :receipt do
  	amount 300
  	paypal_id 'test1234'

  	trait :rider_registration do
  	  association :user, factory: [:user, :rider]
  	end

  	trait :donation do
  	  association :user, factory: [:user, :donor]
  	end

  end
end