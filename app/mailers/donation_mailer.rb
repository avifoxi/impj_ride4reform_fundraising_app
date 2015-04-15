class DonationMailer < ApplicationMailer
  default from: "donations@friendsofimpj.org"

  # def sample_email(donation)
  # 	@donation = donation
  # 	@donor = @donation.user
  # 	@rider = @donation.rider
  # 	mail(to: @donor.email, subject: 'foo bar baz?')
  # end

  def successful_donation_alert_rider(donation)
  	@donation = donation
  	@donor = @donation.user
    # p '$'*80
    # p 'inside mailer function'
    # p '@donor.email'
    # p "#{@donor.email}"
  	@rider = @donation.rider
  	@prp = @rider.persistent_rider_profile
  	@percent_of_goal = @prp.delegate_ryr_method(RideYear.current, 'percent_of_goal')
  	mail(to: @rider.email, subject: "Donation received from #{@donor.full_name}")
  end

  def successful_donation_thank_donor(donation_id)
  	@donation = Donation.find(donation_id)
  	@receipt = @donation.receipt
  	@donor = @donation.user
    org = donation.is_organizational
    unless org
  	 @rider = @donation.rider
     @prp = @rider.persistent_rider_profile
    end
  	mail(to: @donor.email, subject: "Receipt for donation to #{org ? 'IMPJ' : @rider.full_name}")
  end
end
