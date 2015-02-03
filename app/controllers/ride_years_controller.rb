class RideYearsController < ApplicationController

	skip_before_action :authenticate_user!

	def index 
		@ride_years = RideYear.order('year DESC').all
		@current = RideYear.current
	end

	def edit
		@ride_year = RideYear.find(params[:id])
		@current = RideYear.current
	end

	def update 
		@ride_year = RideYear.find(params[:id])
		if @ride_year.update_attributes(ride_year_params)
			redirect_to ride_years_path
		else 
			@errors = @ride_year.errors
			@current = RideYear.current
			render :edit
		end 
	end

	def new 
		@ride_year = RideYear.new
		@current = RideYear.current
	end

	private

	def ride_year_params
    params.require(:ride_year).permit(:registration_fee, :registration_fee_early, :min_fundraising_goal, :year, :ride_start_date, :ride_end_date, :early_bird_cutoff, :set_current_in_form)
  end
end
