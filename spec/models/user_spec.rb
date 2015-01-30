require 'rails_helper'
# require 'spec_helper'


RSpec.describe User, :type => :model do

	it "has a valid factory" do
		user = create(:user)
		expect(user).to be_an_instance_of(User)
	end

	it "selects user's primary address" do
		user = create(:user)
		addy = build(:mailing_address)
		user.mailing_addresses << addy
		expect(user.primary_address).to eq(addy)
	end

	it "assigns user new primary address" do 
		user = create(:user)
		addy = build(:mailing_address)

		user.mailing_addresses << addy
		expect(user.primary_address).to eq(addy)
		addy2 = FactoryGirl.build(:mailing_address, :second)
	
		user.mailing_addresses << addy2
		user.set_new_primary_address(addy2)
		expect(user.primary_address).to eq(addy2)
	end
end
