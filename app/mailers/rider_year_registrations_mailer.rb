class RiderYearRegistrationsMailer < ApplicationMailer
  default from: "rider_year_registrations@ride4reform.com"

  def successful_registration_welcome_rider(ryr)
  	# @donation = donation
  	# @receipt = @donation.receipt
  	# @donor = @donation.user
  	# @rider = @donation.rider
  	# @prp = @rider.persistent_rider_profile
  	mail(to: @rider.email, subject: "Receipt for donation to #{@rider.full_name}")
  end
end
