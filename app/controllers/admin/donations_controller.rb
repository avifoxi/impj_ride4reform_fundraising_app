class Admin::DonationsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def new
		@donation = Donation.new
		@current_riders = RiderYearRegistration.where(ride_year: RideYear.current)
		@donors = User.all
		@donation.build_user
		# @custom_billing_address = MailingAddress.new
	end

	def create

	end

	def new_donation_payment 

	end

end
