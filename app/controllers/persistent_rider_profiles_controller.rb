class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!
	## TODO - ensure defensive authentica_user for all actions allowign edit functions
	skip_before_action :authenticate_user!, only: [:show, :index]

	def show
		@rider = PersistentRiderProfile.find(params[:id])
		@years_registration = @rider.rider_year_registrations.find_by(ride_year: RideYear.current )
		@donations = @rider.delegate_ryr_method(RideYear.current, 'donations')
		@raised = @rider.delegate_ryr_method(RideYear.current, 'raised')
		@percent_of_goal = @rider.delegate_ryr_method(RideYear.current, 'percent_of_goal')
		@goal = @rider.delegate_ryr_method(RideYear.current, 'goal')
	end

	def index
		## does this need to be a function of ride_years?
		@year = RideYear.current
		@riders = RideYear.current.rider_year_registrations.map{|ryr| ryr.persistent_rider_profile}.keep_if{|p| p != nil }
	end

	def edit
		@prp = PersistentRiderProfile.find(params[:id])
		@this_years_registration = @prp.rider_year_registrations.find_by(ride_year: RideYear.current )
		@mailing_addresses = @prp.mailing_addresses
	end

	def update
		@prp = PersistentRiderProfile.find(params[:id])
		@this_years_registration = @prp.rider_year_registrations.find_by(ride_year: RideYear.current )
		
		if @prp.update_attributes(prp_params) && @this_years_registration.update_attributes(ryr_params)
			redirect_to persistent_rider_profile_path(@prp)
		else
			@errors = @prp.errors
			@this_years_registration.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
			@mailing_addresses = @prp.mailing_addresses
			render :edit
		end
	end

	private

	def full_params
    params.require(:persistent_rider_profile).permit(:primary_phone, :secondary_phone, :avatar, :birthdate, :bio, 
    	:rider_year_registration => [
    		:ride_option, :goal
    	],
    	# :amount, :anonymous_to_public, :note_to_rider, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses,
    	# :mailing_addresses_attributes => [
    	# 		:line_1, :line_2, :city, :state, :zip
    	# 	],
    	# :persistent_rider_profile_attributes => [
    	# 		:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
    	# 	],
    	:user => [
    		:first_name, :last_name, :email
    	],
    	:mailing_address => [
    		:line_1, :line_2, :city, :state, :zip
    	]  
    )
  end

  def prp_params
  	full_params.except(:rider_year_registration)
  end

  def ryr_params
  	full_params[:rider_year_registration]
  end

end














