class Admin::CustomRideOptionsController < ApplicationController
	layout "admins"

	skip_before_action :authenticate_user!

	def index
		@year = ride_year
		@options = @year.custom_ride_options
	end

	def new
		@year = ride_year
		@option = @year.custom_ride_options.build
	end

	def create
		ride_year
		@option = @year.custom_ride_options.build( permitted_params )
		if @option.save
			redirect_to admin_ride_year_custom_ride_options_path( @year )
		else
			render :new
		end
	end

	def edit
		@option = CustomRideOption.find(params[:id])
	end

	def update
		@option = CustomRideOption.find(params[:id])
		if @option.update_attributes( permitted_params )
			redirect_to admin_ride_year_custom_ride_options_path( @option.ride_year )
		else
			render :edit
		end
	end

	def destroy 
		@option = CustomRideOption.find(params[:id])
		@option.destroy
		redirect_to admin_ride_year_custom_ride_options_path( @option.ride_year )
	end

	private

	def ride_year
		@year = RideYear.find( params[:ride_year_id] )
	end

	def permitted_params
    params.require(:custom_ride_option).permit(:display_name, :description, :liability_text, :start_date, :end_date, :discount_code, :registration_cutoff, :registration_fee)
	end
end
