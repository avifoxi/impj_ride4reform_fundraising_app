class DonationMailer < ApplicationMailer
  default from: "donations@ride4reform.com"

  # def sample_email(donation)
  # 	@donation = donation
  # 	@donor = @donation.user
  # 	@rider = @donation.rider
  # 	mail(to: @donor.email, subject: 'foo bar baz?')
  # end

  def successful_donation_alert_rider(donation)
  	@donation = donation
  	@donor = @donation.user
  	@rider = @donation.rider
  	@prp = @rider.persistent_rider_profile
  	@percent_of_goal = @prp.delegate_ryr_method(RideYear.current, 'percent_of_goal')
    # subject: "Donation received from #{@donor.full_name}"
  	mail(to: @donor.email) do |format|
      format.html do
        string = render_to_string("successful_donation_alert_rider")
        p '#'*80
        p "#{string.inspect}"
        return string
      end
    end
  end

  def successful_donation_thank_donor(donation)
  	@donation = donation
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
