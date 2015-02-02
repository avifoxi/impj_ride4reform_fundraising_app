FactoryGirl.define do
  factory :admin do
  	password Devise.friendly_token.first(8)
  	email 'admin@test.com'
  end
end