require 'rails_helper'

RSpec.describe RiderYearRegistration, :type => :model do
	let(:ryr) { FactoryGirl.build(:rider_year_registration, :with_valid_associations) }	
	let(:ride_year){ FactoryGirl.create(:ride_year, :current)}

	it "has a valid factory" do 
		ride_year
		expect(ryr).to be_an_instance_of(RiderYearRegistration)
	end

	it "validates goal meets minimum required for ride year" do
		ride_year
		expect( ryr.update_attributes(goal: 50) ).to eq(false)
	end

	it "validates user may not create multiple registrations for one ride year" do
		ride_year
		expect(ryr.save).to eq(true)
		attrs = attributes_for(:rider_year_registration)
		double = ryr.user.rider_year_registrations.new(attrs)
		expect(double.save).to eq(false)
	end

	describe "validates ride options" do 
		it "valid ride options may be submitted" do
			ride_year 
			valid_ride_option = FactoryGirl.build(:rider_year_registration)
			valid_ride_option.ride_option = 'cheese'
			# 'Original Track'        
			# invalid_ride_option.save
			expect( valid_ride_option.save ).to eq( true )
		end
	end

end
