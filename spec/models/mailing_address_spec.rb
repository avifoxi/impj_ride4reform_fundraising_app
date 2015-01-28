require 'rails_helper'

RSpec.describe MailingAddress, :type => :model do
	
	let(:m_ad) { FactoryGirl.build(:mailing_address)}

	it "has a valid factory" do
		expect(m_ad).to be_an_instance_of(MailingAddress)
	end

	it "validates user, rejects if not assigned" do 
		expect(m_ad.save).to be(false)	
	end

	it "validates user, and validates presence / numericality of addy fields" do 

		user = create(:user, :donor)
		m_ad.user = user
		expect(m_ad.save!).to eq(true)

	end
end
