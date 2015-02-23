class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!

	def show
		@rider = PersistentRiderProfile.find(params[:id])
	end
end
