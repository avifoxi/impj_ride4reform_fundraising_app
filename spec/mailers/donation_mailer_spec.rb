require "rails_helper"

RSpec.describe DonationMailer, :type => :mailer do

	let(:receipt) {FactoryGirl.attributes_for(:receipt) }
	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let (:don_params) {FactoryGirl.attributes_for(:donation)}

	before do |example|
		rec = user.receipts.create(receipt)
		@don = user.donations.create({ 
			rider_year_registration: ryr,
			receipt: rec
		}.merge(don_params))	
	end


	it 'should have access to URL helpers' do
    expect { root_url }.not_to raise_error
  end

  context 'successful_donation_alert_rider' do

  	it 'sdlfkjsdl' do
  		p '@don'
  		p "#{@don.inspect}"
  	end

  end

  # expect { subject.send_instructions }.to change { ActionMailer::Base.deliveries.count }.by(1)
end
