class RiderYearRegistrationMailerPreview < ActionMailer::Preview
  def successful_registration_welcome_rider
    RiderYearRegistrationsMailer.successful_registration_welcome_rider(RiderYearRegistration.first)
  end

  def user_register_for_ride_before_payment
    RiderYearRegistrationsMailer.user_register_for_ride_before_payment(RiderYearRegistration.first)
  end

end