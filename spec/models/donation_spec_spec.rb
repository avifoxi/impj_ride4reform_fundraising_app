require 'rails_helper'

RSpec.describe DonationSpec, :type => :model do
	it "has a valid factory" do
		expect( create(:donation_spec) ).to be_an_instance_of(DonationSpec)
	end
end
