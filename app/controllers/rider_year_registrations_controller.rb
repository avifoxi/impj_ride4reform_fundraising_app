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
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
		@ryr.user.build_persistent_rider_profile(user: @ryr.user)
	end

	def new_agree_to_terms
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
	end

	def new_pay_reg_fee

	end

	def create_mailing_address

	end

	def create_persistent_rider_profile
		p '#'*80
		p 'washed full params!!'
		p "#{full_params}"

		p '#'*80

		@ryr = RiderYearRegistration.find(params[:ryr_id])
		prp = @ryr.user.build_persistent_rider_profile(user: @ryr.user)

		if prp.update_attributes(prp_params)
			p '#'*80
			p 'updated guy'
			p "#{@ryr.persistent_rider_profile}"

			p '#'*80
		else
			p '#'*80
			p 'birthdate'
			p "#{prp_params['birthdate']}"

			p '#'*80
			@errors = prp.errors
			render :new_persistent_rider_profile
		end

	end

	def create_agree_to_terms
		@ryr = RiderYearRegistration.find(params[:ryr_id])
		if @ryr.update_attributes(full_params)
			redirect_to rider_year_registrations_persistent_rider_profile_path(rider_year_registration: @ryr)
		else
			@errors = @ryr.errors
			render :new_agree_to_terms
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
    			:primary_phone, :secondary_phone, :photo_upload, :birthdate, :bio
    		] )
  end

  def mailing_addesses_params
  	full_params['mailing_addresses_attributes']['0']
  end

  def prp_params
  	 # "birthdate(1i)"=>"1941", "birthdate(2i)"=>"7", "birthdate(3i)"=>"14"
  	birthdate = Date.new( 
  		full_params['persistent_rider_profile_attributes']["birthdate(1i)"].to_i,
  		full_params['persistent_rider_profile_attributes']["birthdate(2i)"].to_i,
  		full_params['persistent_rider_profile_attributes']["birthdate(3i)"].to_i
  		) 
  	prp_hash = full_params['persistent_rider_profile_attributes']
  	prp_hash['birthdate'] = birthdate
  	prp_hash
  end

  def ryr_params 
  	{
  		ride_option: full_params[:ride_option],
  		goal: full_params[:goal]
  	} 	
  end

end
