class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!

	def new 
		@ryr = RiderYearRegistration.new
	end
end
