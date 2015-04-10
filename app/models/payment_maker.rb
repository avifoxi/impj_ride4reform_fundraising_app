class PaymentMaker

	PAYMENT_TYPE_OUTPUTS = {
		user_rider_year_registration: 'prp_address_redirect',
		user_donation: 'redirect_type',
		admin_rider_year_registration: 'admin_user_url',
		admin_donation: 'admin_donations'
	}

	def initialize(host_model, payment_type, full_params)
		@host_model = host_model
	end

	def validate_cc_info
		@host_model.user.cc_type = cc_info['type']
		@host_model.user.cc_number = cc_info['number']
		@host_model.user.cc_cvv2 = cc_info['cvv2']
		unless @host_model.user.valid?
			prep_errors_hash
			return
		end
	end

	def define_billing_adddress
		if full_params['custom_billing_address'] == '1'
			custom_billing_address = MailingAddress.new(custom_billing_address)
			custom_billing_address.user = current_user
			unless custom_billing_address.save
				prep_errors_hash
				return
			end
			@billing_address = custom_billing_address
		else
			unless full_params['mailing_addresses']
				@host_model.errors.add(:billing_address, 'You must specify a billing address')
				prep_errors_hash
				return
			end
			@billing_address = MailingAddress.find(full_params['mailing_addresses'])
		end
	end
	# def make_payment(host_model, payment_type, params)
	# 	@params = params
	# 	host_model

	# 	if success 
	# 		return redirect_address
	# end

	# def put_pp
	# 	puts @params
	# end

	def prep_errors_hash
		@errors = @host_model.errors
		# return errors json
		if @host_model.user.errors 
			@host_model.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
		end
		if @custom_billing_address && @custom_billing_address.errors
			@custom_billing_address.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
		end
		if @payment_errors
			@errors.add(:payment, @payment_errors)
		end
		return {
			errors: @errors.full_messages.to_sentence
		} 
	end


end

def errors_via_json
	@errors = @ryr.errors
	# return errors json
	if @ryr.user.errors 
		@ryr.user.errors.each do |k,v|
			@errors.messages[k.to_sym] = [v]
		end
	end
	if @custom_billing_address && @custom_billing_address.errors
		@custom_billing_address.errors.each do |k,v|
			@errors.messages[k.to_sym] = [v]
		end
	end
	if @payment_errors
		@errors.add(:payment, @payment_errors)
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

if full_params['custom_billing_address'] == '1'
	@custom_billing_address = MailingAddress.new(custom_billing_address)
	@custom_billing_address.user = current_user
	unless @custom_billing_address.save
		errors_via_json
		return
	end
	billing_address = @custom_billing_address
	else
	unless full_params['mailing_addresses']
		@ryr.errors.add(:billing_address, 'You must specify a billing address')
		errors_via_json
		return
	end
	billing_address = MailingAddress.find(full_params['mailing_addresses'])
end

	ppp = PaypalPaymentPreparer.new({
	user: current_user,
	cc_info: cc_info, 
	billing_address: billing_address,
	transaction_details: transaction_details
	})

if ppp.create_payment
	@ryr.update_attributes(registration_payment_receipt:
		@ryr.create_registration_payment_receipt(user: current_user, amount: current_fee, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)
	)
	@rider = current_user.persistent_rider_profile
	RiderYearRegistrationsMailer.successful_registration_welcome_rider(@ryr).deliver

	render json: {
		success: 'no errors what?',
		prp_address: persistent_rider_profile_url(@rider),
		billing_address: billing_address,
		ryr: @ryr
	} 
else
	@payment_errors = ppp.payment.error
	errors_via_json
end
