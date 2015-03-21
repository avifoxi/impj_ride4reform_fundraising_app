class DonationMailerPreview < ActionMailer::Preview
  def sample_mail_preview
    DonationMailer.sample_email(Donation.first)
  end

  def successful_donation_alert_rider_preview
  	DonationMailer.successful_donation_alert_rider(Donation.first)
  end
end