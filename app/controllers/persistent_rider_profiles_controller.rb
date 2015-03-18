class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!
	## TODO - ensure defensive authentica_user for all actions allowign edit functions
	skip_before_action :authenticate_user!

	def show
		@rider = PersistentRiderProfile.find(params[:id])
		@donations = @rider.delegate_ryr_method(RideYear.current, 'donations')
		@raised = @rider.delegate_ryr_method(RideYear.current, 'raised')
		@percent_of_goal = @rider.delegate_ryr_method(RideYear.current, 'percent_of_goal')
	end

	def index
		## does this need to be a function of ride_years?
		@year = RideYear.current
		@riders = RideYear.current.rider_year_registrations.map{|ryr| ryr.persistent_rider_profile}
	end
end
