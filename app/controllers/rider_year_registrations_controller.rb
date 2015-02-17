class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!
	# skip_before_action :authenticate_user!, only: [:new, :create]

	def new 
		## assume never registered before - brand new 
		@ryr = RiderYearRegistration.new
		# @ryr.build_user
		# @ryr.mailing_addresses.build
		# @ryr.user.build_persistent_rider_profile
	end

	def create 
		@ryr = RiderYearRegistration.new(user: current_user)
		if @ryr.update_attributes(ryr_params)
			redirect_to rider_year_registrations_agree_to_terms_path(rider_year_registration: @ryr)
		else
			@errors = @ryr.errors
			render :new
		end
	end

	def new_mailing_address

	end

	def new_persistent_rider_profile

	end

	def new_agree_to_terms
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
	end

	def new_pay_reg_fee

	end

	def create_mailing_address

	end

	def create_persistent_rider_profile

	end

	def create_agree_to_terms
		p "#"*80
		puts "full_params"
		p "#{full_params.inspect}"
		@ryr = RiderYearRegistration.find(params[:ryr_id])
		if @ryr.update_attributes(agree_to_terms: full_params)
			p 'UPDATED'
			redirect_to rider_year_registrations_agree_to_terms_path(rider_year_registration: @ryr)
		end

	end

	def create_registrations_pay_fee

	end

	private 

	def full_params
    params.require(:rider_year_registration).permit(:ride_option, :goal, :agree_to_terms,
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :birthdate, :bio
    		] )
  end

  def mailing_addesses_params
  	full_params['mailing_addresses_attributes']['0']
  end

  def per_params
  	full_params['persistent_rider_profile_attributes']
  end

  def ryr_params 
  	{
  		ride_option: full_params[:ride_option],
  		goal: full_params[:goal]
  	} 	
  end

end
