class PersistentRiderProfilesController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!, only: [:show, :index]
	before_action :validate_user_w_associated_prp, only: [:edit, :update, :deactivate_current_ryr]
	
	def show
		@rider = PersistentRiderProfile.find(params[:id])
		@years_registration = @rider.rider_year_registrations.last

		if @years_registration.ride_year != RideYear.current
			@ask_for_current_participation = true
			flash[:notice] = 'Sign up for this years ride! Click below your photo.'
		end

		# @years_registration = @rider.rider_year_registrations.find_by(ride_year: RideYear.current )
		@prp_owner_signed_in = @rider.user == current_user


		if !@years_registration.active_for_fundraising
			if @prp_owner_signed_in
				flash[:alert] = "#{@years_registration.full_name} no longer active for this year's ride."
			else 
				flash[:notice] = "#{@years_registration.full_name} not active for this year's ride."
				redirect_to persistent_rider_profiles_path
			end
		end
			
		@donations = @years_registration.donations
		@raised = @years_registration.raised
		@percent_of_goal = @years_registration.percent_of_goal
		@goal = @years_registration.goal
		
	end

	def index
		@year = RideYear.current
		@riders = RideYear.current.rider_year_registrations.where(active_for_fundraising: true).map{|ryr| ryr.persistent_rider_profile}.keep_if{|p| p != nil }
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

	def deactivate_current_ryr

		@prp = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@prp.rider_year_registrations.find_by(ride_year: RideYear.current ).deactivate
		redirect_to persistent_rider_profile_path(@prp)

	end

	def reactivate_current_ryr

		@prp = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@prp.rider_year_registrations.find_by(ride_year: RideYear.current ).reactivate
		flash[:notice] = "#{@prp.full_name} reactivated for this year's ride."

		redirect_to persistent_rider_profile_path(@prp)

	end

	private

	def validate_user_w_associated_prp
		id = params[:id] || params[:persistent_rider_profile_id]
		@prp = PersistentRiderProfile.find(id)
		unless @prp.user == current_user
			flash[:alert] = "Please log in to your own account to edit your profile."
      redirect_to root_path
    end
	end

	def full_params
    params.require(:persistent_rider_profile).permit(:primary_phone, :secondary_phone, :avatar, :birthdate, :bio, 
    	:rider_year_registration => [
    		:ride_option, :goal
    	],
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














