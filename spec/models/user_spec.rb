require 'rails_helper'
# require 'spec_helper'


RSpec.describe User, :type => :model do

	it "has a valid factory" do
		user = create(:user, :rider)
		expect(user).to be_an_instance_of(User)
	end

	it "selects user's primary address" do
		user = create(:user, :rider)
		addy = build(:mailing_address)
		user.mailing_addresses << addy
		expect(user.primary_address).to eq(addy)
	end

	it "assigns user new primary address" do 
		user = create(:user, :rider)
		addy = build(:mailing_address)

		user.mailing_addresses << addy
		expect(user.primary_address).to eq(addy)
		addy2 = FactoryGirl.build(:mailing_address, :second)
	
		user.mailing_addresses << addy2
		user.set_new_primary_address(addy2)
		expect(user.primary_address).to eq(addy2)
	end

	it "validates credit card info when sent to model" do 
		user = create(:user, :rider)
		user.cc_type = 'i am not a credit card type...'
		expect(user.save).to eq(false)
		expect(user.errors).not_to be_empty
	end
end
