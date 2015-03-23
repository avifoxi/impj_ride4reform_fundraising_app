class RiderYearRegistrationMailerPreview < ActionMailer::Preview
  def successful_registration_welcome_rider
    RiderYearRegistrationsMailer.sample_email(RiderYearRegistration.first)
  end
end