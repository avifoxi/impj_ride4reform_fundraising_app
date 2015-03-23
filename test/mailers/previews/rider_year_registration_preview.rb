class RiderYearRegistrationMailerPreview < ActionMailer::Preview
  def successful_registration_welcome_rider
    RiderYearRegistrationsMailer.successful_registration_welcome_rider(RiderYearRegistration.first)
  end
end