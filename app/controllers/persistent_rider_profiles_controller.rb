class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!
	## TODO - ensure defensive authentica_user for all actions allowign edit functions
	skip_before_action :authenticate_user!

	def show
		@rider = PersistentRiderProfile.find(params[:id])
	end

	def index
		## does this need to be a function of ride_years?
		@riders = PersistentRiderProfile
	end
end
