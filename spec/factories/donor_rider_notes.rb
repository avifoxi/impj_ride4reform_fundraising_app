# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :donor_rider_note do
    rider_year_registration nil
    receipt nil
    visible_to_public false
    note_to_rider "MyText"
  end
end
