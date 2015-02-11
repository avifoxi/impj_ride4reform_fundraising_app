class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!
	# skip_before_action :authenticate_user!, only: [:new, :create]

	def new 
		## assume never registered before - brand new 
		@ryr = RiderYearRegistration.new
		@ryr.mailing_addresses.build
		@ryr.user.build_persistent_rider_profile
	end


end
