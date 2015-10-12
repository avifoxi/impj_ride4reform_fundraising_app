class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!

	before_action :redirect_if_public_site_is_not_active
	before_action :validate_user_w_associated_ryr, except: [:new, :create]

	def new
		## assume never registered before - brand new ... and deal with alternative scenario once this is built
		@ryr = RiderYearRegistration.new
		options = RideYear.current.custom_ride_options
		unless options.empty?
			@options = options.map{|o| [ o.display_name, o.id ] }
		end
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

	def new_agree_to_terms
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
	end

	def create_agree_to_terms
		@ryr = RiderYearRegistration.find(params[:ryr_id])
		if @ryr.update_attributes(full_params)
			
			if current_user.persistent_rider_profile 
				redirect_to rider_year_registrations_pay_reg_fee_path(rider_year_registration: @ryr)
			else # ie a first time rider
				redirect_to rider_year_registrations_persistent_rider_profile_path(rider_year_registration: @ryr)
			end

		else
			@errors = @ryr.errors
			render :new_agree_to_terms
		end
	end

	def new_persistent_rider_profile
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
		@prp = @ryr.user.build_persistent_rider_profile(user: @ryr.user)
	end

	def create_persistent_rider_profile
		@ryr = RiderYearRegistration.find(params[:ryr_id])
		@prp = @ryr.user.build_persistent_rider_profile(user: @ryr.user)

		if @prp.update_attributes(prp_params)
			redirect_to rider_year_registrations_mailing_address_path(rider_year_registration: @ryr)
		else
			@errors = @prp.errors
			render :new_persistent_rider_profile
		end

	end

	def new_mailing_address
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
		@ryr.mailing_addresses.build
	end

	def create_mailing_address
		@ryr = RiderYearRegistration.find(params[:ryr_id])
		m_a = @ryr.mailing_addresses.build(user: @ryr.user)

		if m_a.update_attributes(mailing_addesses_params)
			redirect_to rider_year_registrations_pay_reg_fee_path(rider_year_registration: @ryr)
		else
			@errors = m_a.errors
			render :new_mailing_address
		end
	end

	def new_pay_reg_fee
		@ryr = RiderYearRegistration.find(params[:rider_year_registration])
		@mailing_addresses = @ryr.mailing_addresses
		@custom_billing_address = MailingAddress.new
		# @registration_fee = RideYear.current_fee
	end

	def create_pay_reg_fee

		@ryr = RiderYearRegistration.find(params[:ryr_id])
		pm = PaymentMaker.new(@ryr, :registration, full_params)
		begin
			@receipt_or_errors = pm.process_payment
		rescue
			render json: {
				errors: "We're very sorry, but there was an error connecting to PayPal."
			}
			return  
		end
		if @receipt_or_errors.instance_of?(Receipt)
			@rider = current_user.persistent_rider_profile
			RiderYearRegistrationsMailer.successful_registration_welcome_rider(@ryr).deliver
			render json: {
				success: 'no errors what?',
				prp_address: persistent_rider_profile_url(@rider),
				ryr: @ryr
			} 
		else
			render json: @receipt_or_errors
		end
	end

	private 

	def validate_user_w_associated_ryr
		id_num = params[:ryr_id] || params[:rider_year_registration]
		ryr = RiderYearRegistration.find(id_num)
		unless ryr.user == current_user
			flash[:error] = "Please log in to your own account to register."
      redirect_to new_user_session_path
    end
	end

	def full_params
    params.require(:rider_year_registration).permit(:ride_option, :goal, :agree_to_terms, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses, :discount_code, :custom_ride_option,
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
    		],
    	:mailing_address => [
    		:line_1, :line_2, :city, :state, :zip
    	] 
    )
  end


  def mailing_addesses_params
  	full_params['mailing_addresses_attributes']['0']
  end

  def prp_params
  	full_params['persistent_rider_profile_attributes']
  end

  def ryr_params 
  	{
  		ride_option: full_params[:ride_option],
  		goal: full_params[:goal],
  		discount_code: full_params[:discount_code],
  		custom_ride_option: full_params[:custom_ride_option] ? CustomRideOption.find(full_params[:custom_ride_option]) : nil
  	} 	
  end


end
