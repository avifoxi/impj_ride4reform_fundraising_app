class DonationMailerPreview < ActionMailer::Preview
  def sample_mail_preview
    DonationMailer.sample_email(Donation.first)
  end

  def successful_donation_alert_rider_preview
  	DonationMailer.successful_donation_alert_rider(Donation.first)
  end

  def successful_donation_w_rider_thank_donor
  	DonationMailer.successful_donation_thank_donor(Donation.first)
  end

  def successful_donation_to_org_thank_donor
  	d_org = User.first.donations.build(
      note_to_rider: 'i love bikes muchly',
      receipt: Receipt.create(
    		user: User.first,
      	amount: 300,
      	paypal_id: 'testmeoohllala',
      ),
      amount: 300,
     	fee_is_processed: true,
      is_organizational: true,
  	)
  	DonationMailer.successful_donation_thank_donor(d_org)
  end
end