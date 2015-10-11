class Admin::CustomRideOptionsController < ApplicationController

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
		year = RideYear.find( params[:ride_year_id] )
		option = year.custom_ride_options.build( permitted_params )
		if option.save
			# force page reload? yes
		else
			# # return form w errors
			# binding.pry
			# foo = render_to_string('admin/custom_ride_options/_form', locals: { custom_ride_option: option }), 
			# custom_ride_option: option,
			# c_r_o_url:  admin_ride_year_custom_ride_options_path( year )
			# binding.pry
		end

	end

	private

	def ride_year
		RideYear.find( params[:ride_year_id] )
	end

	def permitted_params
    params.require(:custom_ride_option).permit(:display_name, :description, :liability_text, :start_date, :end_date, :discount_code, :registration_cutoff, :registration_fee)
	end
end
