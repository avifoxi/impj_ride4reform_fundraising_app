class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!

	before_action :validate_user_w_associated_ryr, except: [:new, :create]

	def new 
		## assume never registered before - brand new ... and deal with alternative scenario once this is built
		@ryr = RiderYearRegistration.new
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
			redirect_to rider_year_registrations_persistent_rider_profile_path(rider_year_registration: @ryr)
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
		prp = @ryr.user.build_persistent_rider_profile(user: @ryr.user)

		if prp.update_attributes(prp_params)
			# user_register_for_ride_before_payment
			# RiderYearRegistrationsMailer.successful_registration_welcome_rider(@ryr)

			redirect_to rider_year_registrations_mailing_address_path(rider_year_registration: @ryr)
		else
			@errors = prp.errors
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
		@registration_fee = current_fee
	end

	def create_pay_reg_fee
		p 'params ajax'
		p "#{params.inspect}"

		@ryr = RiderYearRegistration.find(params[:ryr_id])

		def errors_via_json
			@errors = @ryr.errors
			# return errors json
			if @ryr.user.errors 
				@ryr.user.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			render json: {
				errors: @errors.full_messages.to_sentence
			} 
			return
		end

		if cc_info
			@ryr.user.cc_type = cc_info['type']
			@ryr.user.cc_number = cc_info['number']
			@ryr.user.cc_cvv2 = cc_info['cvv2']
			unless @ryr.user.valid?
				errors_via_json
				return
			end
		else
			@payment_errors = ['Please enter your full credit card information to complete your registration']
			errors_via_json
			return
		end

		# if full_params['custom_billing_address'] == '1'
		# 	@custom_billing_address = MailingAddress.new(custom_billing_address)
		# 	@custom_billing_address.user = current_user
		# 	unless @custom_billing_address.save
		# 		@errors = @custom_billing_address.errors
		# 		@mailing_addresses = @ryr.mailing_addresses
		# 		render :new_pay_reg_fee
		# 		return
		# 	end
		# 	billing_address = @custom_billing_address
		# else
		# 	billing_address = MailingAddress.find(full_params['mailing_addresses'])
		# end
	
		# ppp = PaypalPaymentPreparer.new({
		# 	user: current_user,
		# 	cc_info: cc_info, 
		# 	billing_address: billing_address,
		# 	transaction_details: transaction_details
		# })

		# if ppp.create_payment
		# 	@ryr.update_attributes(registration_payment_receipt:
		# 		@ryr.create_registration_payment_receipt(user: current_user, amount: current_fee, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)
		# 	)
		# 	@rider = current_user.persistent_rider_profile
		# 	RiderYearRegistrationsMailer.successful_registration_welcome_rider(@ryr).deliver

		# 	flash[:notice] = "Thank you for registering to ride!"
		# 	redirect_to persistent_rider_profile_path(@rider)
		# else
		# 	@payment_errors = ppp.payment.error
		# 	@mailing_addresses = @ryr.mailing_addresses
		# 	unless @custom_billing_address
		# 		@custom_billing_address = MailingAddress.new
		# 	end
		# 	@registration_fee = current_fee

		# 	render :new_pay_reg_fee
		# end
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
    params.require(:rider_year_registration).permit(:ride_option, :goal, :agree_to_terms, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses,
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

  def cc_info
  	unless full_params['cc_type'] && full_params['cc_number'] && full_params['cc_expire_month'] && full_params['cc_expire_year(1i)'] && full_params['cc_cvv2']
  		return false
  	end
  	{
  		'type' => full_params['cc_type'],
			'number' => full_params['cc_number'],
			'expire_month' => full_params['cc_expire_month'],
			'expire_year' => full_params['cc_expire_year(1i)'],
			'cvv2' => full_params['cc_cvv2']
  	}
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
  		goal: full_params[:goal]
  	} 	
  end

  def custom_billing_address
		full_params['mailing_address']	
  end

  def current_fee 
  	if Date.today < RideYear.current.early_bird_cutoff
  		RideYear.current.registration_fee_early
  	else
  		RideYear.current.registration_fee
  	end
  end

  def transaction_details
  	{
			'name' => "rider registration fee",
			'amount' =>  '%.2f' % current_fee,
			'description' => "Registration fee for #{ current_user.full_name }, #{RideYear.current.year}"
		}
	end

end
