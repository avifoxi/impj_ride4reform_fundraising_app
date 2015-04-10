class Admin::RiderYearRegistrationsController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	# /admin/ride_years/:ride_year_id/rider_year_registrations
	# /admin/rider_year_registrations
	def index
		@ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@ryrs = @ride_year.rider_year_registrations
	
		respond_to do |format|
      format.html {
      	@all_ride_years = RideYear.all
      	unless @ryrs.empty?
	      	@avg_raised = @ride_year.avg_raised_by_rider
					@avg_perc = @ride_year.avg_perc_of_rider_goal_met  
					@total_raised = @ride_year.total_raised
				end
      }
      format.csv { 
      	send_data gen_csv(@ryrs, [:full_name, :ride_option, :goal, :raised, :percent_of_goal])  
      	response.headers['Content-Disposition'] = 'attachment; filename="' + "registered_rider_stats_#{Time.now.strftime("%Y_%m_%d_%H%M")}" + '.csv"'
      }
    end
	end

	def new
		@user = User.find(params[:user_id])
		@ryr = @user.rider_year_registrations.build
	end

end
