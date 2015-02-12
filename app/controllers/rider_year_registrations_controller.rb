class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!
	# skip_before_action :authenticate_user!, only: [:new, :create]

	def new 
		## assume never registered before - brand new 
		@ryr = RiderYearRegistration.new
		@ryr.build_user
		@ryr.mailing_addresses.build
		@ryr.user.build_persistent_rider_profile
	end

	def create 
		p "#"*80
		p 'these be params'
		p "#{params.inspect}"
		p "#"*80

		p "#"*80
		p 'these be processed ryr_params'
		p "#{ryr_params.inspect}"
		p "#"*80

		
	end

	private 

	def ryr_params
    params.require(:rider_year_registration).permit(:ride_option, :goal, user_attributes: [
    		:mailing_address => [
    			:line_1, :line_2, :city, :state, :zip
    		], 
    		:persistent_rider_profile => [
    			:primary_phone, :secondary_phone, :birthdate, :bio
    		]
    	])
  end

end
