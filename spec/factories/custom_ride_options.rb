# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_ride_option do
    display_name "Custom Ride"
    description "MyText"
    start_date "2015-08-16"
    end_date "2015-08-16"
    discount_code "MyString"
    registration_cutoff "2015-08-16"
    registration_fee 500
    association :ride_year, factory: [:ride_year, :current]
  end
end
