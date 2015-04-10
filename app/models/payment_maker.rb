class PaymentMaker

	PAYMENT_TYPES = [:donation, :registration]
	
	## If successful payment, return receipt
	## else, return errors

	def initialize(host_model, payment_type, full_params, admin=nil)
		@host_model = host_model
		@payment_type = payment_type
		@full_params = full_params
		@amount = @payment_type == :registration ? RideYear.current_fee : @full_params[:amount].to_i
		@by_check = admin && ( @full_params[:receipt][:by_check] == "1" )
	end

	def process_payment
		unless inputs_are_valid
			return prep_errors_hash
		end
		if @by_check
			prep_and_return_receipt
		else
			call_paypal
		end
	end

	def inputs_are_valid
		validate_cc_info && define_billing_adddress &&prep_transaction_details
	end

	def validate_cc_info
		@host_model.user.cc_type = @full_params[:cc_type]
		@host_model.user.cc_number = @full_params[:cc_number]
		@host_model.user.cc_cvv2 = @full_params[:cc_cvv2]
		@host_model.user.valid?	
	end

	def define_billing_adddress
		if @full_params['custom_billing_address'] == '1'
			custom_billing_address = MailingAddress.new(custom_billing_address_params)
			custom_billing_address.user = @host_model.user
			@billing_address = custom_billing_address
		else
			if @full_params['mailing_addresses'] == nil
				@host_model.errors.add(:billing_address, 'You must specify a billing address.')
				return false
			end
			@billing_address = MailingAddress.find(@full_params['mailing_addresses'])
		end

		# p 'billing_address'
		# p "#{@billing_address.inspect}"
		@billing_address.save
		@billing_address.valid?
	end

	def prep_transaction_details
		@transaction_details = {
			'name' => @payment_type.to_s.humanize,
			'amount' =>  '%.2f' % @amount,
			'description' => 
				@payment_type.to_s.match('registration') ? 
					"Registration fee for #{ @host_model.full_name }, #{RideYear.current.year}" 
					: 
					'this must be a donation... placeholder'
		}
		
	end

	def call_paypal
		@ppp = PaypalPaymentPreparer.new({
			user: @host_model.user,
			cc_info: cc_info, 
			billing_address: @billing_address,
			transaction_details: @transaction_details
		})
		if @ppp.create_payment
			prep_and_return_receipt
		else
			@host_model.errors.add(:payment, ppp.payment.error)
			prep_errors_hash
		end
	end

	def prep_and_return_receipt
		if @by_check
			@receipt_params = {}
		else
			@receipt_params = {
				user: @host_model.user, 
				amount: @amount, 
				paypal_id: @ppp.payment.id, 
				full_paypal_hash: @ppp.payment.to_json
			}
		end
		if @payment_type == :registration
			return @host_model.create_registration_payment_receipt(@receipt_params)
		else
			return @host_model.create_receipt(@receipt_params)
		end
	end

	def cc_info
  	{
  		'type' => @full_params['cc_type'],
			'number' => @full_params['cc_number'],
			'expire_month' => @full_params['cc_expire_month'],
			'expire_year' => @full_params['cc_expire_year(1i)'],
			'cvv2' => @full_params['cc_cvv2']
  	}
  end

  def custom_billing_address_params
		@full_params['mailing_address']	
  end
	
	def prep_errors_hash
		@errors = @host_model.errors
		# return errors json
		if @host_model.user.errors 
			@host_model.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
		end
		if @billing_address && @billing_address.errors
			@billing_address.errors.each do |k,v|
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