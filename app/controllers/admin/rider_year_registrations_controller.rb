class Admin::RiderYearRegistrationsController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	# /admin/ride_years/:ride_year_id/rider_year_registrations
	# /admin/rider_year_registrations
	def index
		@ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@all_ride_years = RideYear.all
		@ryrs = @ride_year.rider_year_registrations
		@avg_raised = @ride_year.avg_raised_by_rider
		@avg_perc = @ride_year.avg_perc_of_rider_goal_met  
		@total_raised = @ride_year.total_raised

		respond_to do |format|
      format.html
      format.csv { send_data gen_csv(@ryrs, [:full_name, :ride_option, :goal, :raised, :percent_of_goal])  }
    end
	end

end
