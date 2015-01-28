require 'rails_helper'

RSpec.describe RiderYearRegistration, :type => :model do
	let(:ryr) { FactoryGirl.create(:rider_year_registration) }	

	it "has a valid factory" do 
		expect(ryr).to be_an_instance_of(RiderYearRegistration)
	end

	it "validates goal meets minimum required for ride year" do
		expect( ryr.update_attributes(goal: 50) ).to eq(false)
	end



end
