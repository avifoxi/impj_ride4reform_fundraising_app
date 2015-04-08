class Admin::UsersController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def index 
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		if @user.persistent_rider_profile
			@prp = @user.persistent_rider_profile
			@all_rides = @user.rider_year_registrations
			if @user.rider_year_registrations.find_by(ride_year: RideYear.current)
				@current_ryr = @user.rider_year_registrations.find_by(ride_year: RideYear.current)
			end
		end
		unless @user.donations.empty?
			@donations = @user.donations
		end
		if @user.mailing_addresses
			@mailing_addresses = @user.mailing_addresses
		end 
	end
end
