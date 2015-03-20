require 'rails_helper'

RSpec.describe Donation, :type => :model do
  let(:don) { FactoryGirl.build(:donation, :with_valid_associations_before_fee_processed)}

	it "has a valid factory" do
		expect( don ).to be_an_instance_of(Donation)
	end

	# it "correctly associates to aliased donor" do 
	# 	expect(don.donor.first_name).to eq("Donor")
	# end

	it "correctly associates to aliased rider" do 
		expect(don.rider.first_name).to eq("Rider")
	end
end
