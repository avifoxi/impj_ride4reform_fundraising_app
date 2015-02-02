class RideYearsController < ApplicationController

	skip_before_action :authenticate_user!

	def index 
		@ride_years = RideYear.order('year DESC').all
		@current = RideYear.current
	end

	def edit
		@ride_year = RideYear.find(params[:id])
	end
end
