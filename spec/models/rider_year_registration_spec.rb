require 'rails_helper'

RSpec.describe RiderYearRegistration, :type => :model do
	let(:ryr) { FactoryGirl.build(:rider_year_registration, :with_valid_associations) }	
	let(:ride_year){ FactoryGirl.create(:ride_year, :current)}

	before :each do 
		ride_year
	end

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

	describe "validates ride options" do
		before :each do
			ride_year.custom_ride_options.create( FactoryGirl.attributes_for( :custom_ride_option ) ) 
		end

		it "invalid ride options may not be submitted" do
			invalid_ride_option = FactoryGirl.build(:rider_year_registration)
			invalid_ride_option.ride_option = 'cheese'
			expect( invalid_ride_option.save ).to eq( false )
		end

		it "valid custom ride option rejected without correct discount code" do
			valid_sans_code = FactoryGirl.build(:rider_year_registration)
			valid_sans_code.ride_option = ride_year.custom_ride_options.first.display_name
			expect( valid_sans_code.save ).to eq( false )
		end

		it "valid custom_ride_option accepted with correct discount code" do
			valid = FactoryGirl.build( :rider_year_registration )
			valid.ride_option = CustomRideOption.first.display_name
			valid.discount_code = CustomRideOption.first.discount_code
			expect( valid.save ).to eq( true )
		end
	end

end
