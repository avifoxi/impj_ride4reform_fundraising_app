require 'rails_helper'

RSpec.describe RideYear, :type => :model do
	let(:old_year) { FactoryGirl.create(:ride_year, :old) }	
	let(:current_year) { FactoryGirl.create(:ride_year, :current) }

	it "has a valid factory" do 
		expect(current_year).to be_an_instance_of(RideYear)
	end

	it "can set and get current year" do 
		current_year
		old_year.set_as_current
		expect(old_year.current).to eq(2)
		expect(RideYear.current).to eq(old_year)
	end

	it "returns basic options when NO custom options are assigned" do 
		expect( old_year.options ).to eq( ["Original Track", "Light Track"] )
	end

	it "returns basic and custom options in single array of option names when custom options are assigned" do 
		old_year.custom_ride_options << FactoryGirl.create( :custom_ride_option )
		expect( old_year.options ).to eq( ["Original Track", "Light Track", "Custom Ride"] )
	end

end
