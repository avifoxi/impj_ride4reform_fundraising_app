class DonationMailerWorker
  include Sidekiq::Worker

  def perform(donation_id)
    donation = Donation.find(donation_id)
    DonationMailer.successful_donation_thank_donor(donation)
  end
end