class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!, only: [:new, :create]

	def new 


		@ryr = RiderYearRegistration.new
		if !current_user
			@ryr.user.new
		end
	end


	def first_time_rider_new_user_form

	end
end
