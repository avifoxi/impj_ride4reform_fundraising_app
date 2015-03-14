class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!
	## TODO - ensure defensive authentica_user for all actions allowign edit functions
	skip_before_action :authenticate_user!

	def show
		@rider = PersistentRiderProfile.find(params[:id])
	end

	def index
		## does this need to be a function of ride_years?
		@year = RideYear.current
		@riders = RideYear.current.rider_year_registrations.map{|ryr| ryr.persistent_rider_profile}
	end
end
