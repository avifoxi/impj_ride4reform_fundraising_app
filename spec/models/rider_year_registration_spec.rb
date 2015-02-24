require 'rails_helper'

RSpec.describe RiderYearRegistration, :type => :model do
	let(:ryr) { FactoryGirl.build(:rider_year_registration, :with_valid_associations) }	
	let(:ride_year){ FactoryGirl.create(:ride_year, :current)}

	it "has a valid factory" do 
		expect(ryr).to be_an_instance_of(RiderYearRegistration)
	end

	it "validates goal meets minimum required for ride year" do
		expect( ryr.update_attributes(goal: 50) ).to eq(false)
	end

	it "validates user may not create multiple registrations for one ride year" do
		expect(ryr.save).to eq(true)
		attrs = attributes_for(:rider_year_registration)
		double = ryr.user.rider_year_registrations.new(attrs)
		expect(double.save).to eq(false)
	end

	it "validates only valid ride options may be submitted" do 
		invalid_ride_option = FactoryGirl.build(:rider_year_registration)
		invalid_ride_option.ride_option = 'navel gazing'
		ride_year
		invalid_ride_option.save
		expect(invalid_ride_option.save).to eq(false)
	end

end
