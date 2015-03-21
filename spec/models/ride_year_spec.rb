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

end
