require 'rails_helper'

RSpec.describe DonorRiderNote, :type => :model do

	let(:drn) { FactoryGirl.build(:donor_rider_note)}

	it "has a valid factory" do
		expect( drn ).to be_an_instance_of(DonorRiderNote)
	end

	it "correctly associates to aliased donor" do 
		expect(drn.donor.first_name).to eq("Donor")
	end

	it "correctly associates to aliased rider" do 
		expect(drn.rider.first_name).to eq("Rider")
	end
end
