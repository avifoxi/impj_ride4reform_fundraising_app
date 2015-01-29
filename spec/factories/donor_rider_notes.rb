# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donor_rider_note do
    visible_to_public true
    note_to_rider "I donate to you for riding your bike"
  
    association :rider_year_registration, factory: :rider_year_registration
    association :receipt, factory: [:receipt, :donation]
  end
end
