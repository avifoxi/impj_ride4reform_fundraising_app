require "rails_helper"

RSpec.describe DonationMailer, :type => :mailer do

	let(:receipt) {FactoryGirl.attributes_for(:receipt) }
	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let (:don_params) {FactoryGirl.attributes_for(:donation)}
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }

	before do |example|
		rec = user.receipts.create(receipt)
		ryr.user.create_persistent_rider_profile({
			user: ryr.user
		}.merge(prp_params))
		@don = user.donations.create({ 
			rider_year_registration: ryr,
			receipt: rec
		}.merge(don_params))
		# p 'testing donation'
		# p 'don.user'
		# p "#{don.user.inspect}"

		@mail = DonationMailer.successful_donation_alert_rider(@don)	
	end


	it 'should have access to URL helpers' do
    expect { root_url }.not_to raise_error
  end

  context 'successful_donation_alert_rider' do
  	
  	it 'renders the subject' do
      expect(@mail.subject).to eql("Donation received from #{user.full_name}")
    end

    it 'renders the receiver email address' do
      expect(@mail.to).to eql([ryr.email])
    end
 
    it 'renders the sender email' do
      expect(@mail.from).to eql(["donations@friendsofimpj.org"])
    end
 
    it 'assigns @name' do
      expect(@mail.body.encoded).to match(user.full_name)
    end
 
    it 'assigns correct user email for rider to thank' do
      expect(@mail.body.encoded).to match(user.email)
    end

  end

  # expect { subject.send_instructions }.to change { ActionMailer::Base.deliveries.count }.by(1)
end
