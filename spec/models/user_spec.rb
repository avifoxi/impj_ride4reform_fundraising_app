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
		# this passes
		addy2.update_attributes(user: user)

		# user.mailing_addresses << addy2
		# puts "#{MailingAddress.last.inspect}"
		user.set_new_primary_address(addy2)
		# puts "#{MailingAddress.last.inspect}"
		# puts "#{user.primary_address.inspect} user.primary_address"
		expect(user.primary_address).to eq(MailingAddress.last)
	end
end
