class Admin::RiderYearRegistrationsController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	# /admin/ride_years/:ride_year_id/rider_year_registrations
	# /admin/rider_year_registrations
	def index
		@ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@all_ride_years = RideYear.all
		@ryrs = @ride_year.rider_year_registrations
		@avg_raised = (@ryrs.map{|r| r.raised}.inject{|sum, n| sum + n}.to_f / @ryrs.count).to_i  
		@avg_perc = (@ryrs.map{|r| r.percent_of_goal.to_i}.inject{|sum, n| sum + n}.to_f / @ryrs.count).to_i  
		@total_raised = @ride_year.donations.where("fee_is_processed = ?", true).sum(:amount)
	end
end
