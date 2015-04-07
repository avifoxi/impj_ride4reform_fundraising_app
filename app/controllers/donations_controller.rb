class DonationsController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!

	def new
		@donation = Donation.new
		@donation.build_user
		if params[:persistent_rider_profile_id]
			@rider = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
			render :new_for_rider
		else
			@donation.is_organizational = true
			render :new_for_organization
		end
	end

	def create
		@donation = Donation.new(full_params.except(:user))

		def error_n_render
			@donation.user = @user
			@donation.valid?
			@errors = @donation.errors
			@donation.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
			render params[:persistent_rider_profile_id] ? :new_for_rider : :new_for_organization
		end

		if current_user 
			@user = current_user
		else
			@user = User.find_by(email: full_params[:user][:email])
		end

		unless @user
			@user = User.new(full_params[:user])
			@user.title = 'None'
			@user.password = Devise.friendly_token.first(8)
			unless @user.save
				error_n_render
				return
			end
		end

		if params[:persistent_rider_profile_id]
			# TODO -- error handling if rider not found in db ? ?
			@rider = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
			@donation.rider_year_registration = @rider.current_registration
		end	
		@donation.user = @user

		if @donation.save 
			# p '#'*80
			# p '@don'
			# p "#{@donation.inspect}"
			redirect_to new_donation_payment_path(@donation)
		else
			error_n_render
		end
	end

	def new_donation_payment
		@donation = Donation.find(params[:id])
		unless @donation.mailing_addresses.empty?
			@mailing_addresses = @donation.mailing_addresses
		end
		@custom_billing_address = MailingAddress.new	
	end

	def create_donation_payment
		@donation = Donation.find(params[:id])

		def re_render_new_dp_w_errors
			@errors = @donation.errors
			if @donation.user.errors 
				@donation.user.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			if @custom_billing_address && @custom_billing_address.errors
				@custom_billing_address.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			render json: {
				errors: @errors.full_messages.to_sentence
			} 
			return
		end
		
		if cc_info
			@donation.user.cc_type = cc_info['type']
			@donation.user.cc_number = cc_info['number']
			@donation.user.cc_cvv2 = cc_info['cvv2']
			unless @donation.user.valid?
				re_render_new_dp_w_errors
				return
			end
		else
			@donation.errors.add(:payment, 'Please enter your full credit card information to complete your registration')
			re_render_new_dp_w_errors
			return
		end

		if full_params['custom_billing_address'] == '0' && !full_params['mailing_addresses'] 
			@donation.errors.add(:billing_address, 'You must select a mailing address.')			
			re_render_new_dp_w_errors
			return
		end

		if full_params['custom_billing_address'] == '1'
			@custom_billing_address = MailingAddress.new(full_params['mailing_address'])
			@custom_billing_address.user = @donation.user
			unless @custom_billing_address.save
				re_render_new_dp_w_errors
				return
			end
			billing_address = @custom_billing_address
		else
			billing_address = MailingAddress.find(full_params['mailing_addresses'])
		end

		ppp = PaypalPaymentPreparer.new({
			user: @donation.user,
			cc_info: cc_info, 
			billing_address: billing_address,
			transaction_details: transaction_details
		})

		if ppp.create_payment
			receipt = Receipt.create(user: @donation.user, amount: @donation.amount, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)
			@donation.update_attributes(receipt: receipt, fee_is_processed: true)	
			DonationMailer.successful_donation_thank_donor(@donation).deliver
			
			unless @donation.is_organizational
				rider = @donation.rider.persistent_rider_profile
				DonationMailer.successful_donation_alert_rider(@donation).deliver
			end
			render json: {
				success: 'no errors what?',
				redirect_address: @donation.is_organizational ? root_url : persistent_rider_profile_url(rider)
			} 
		else
			@donation.errors.add(:payment, ppp.payment.error)
			re_render_new_dp_w_errors
		end
	end

	private

	def full_params
    params.require(:donation).permit(:amount, :anonymous_to_public, :note_to_rider, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses, :is_organizational,
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
    		],
    	:user => [
    		:first_name, :last_name, :email
    	],
    	:mailing_address => [
    		:line_1, :line_2, :city, :state, :zip
    	]  
    )
  end

  def transaction_details
    {
      'name' => "user donation to #{@donation.is_organizational ? 'IMPJ' : 'rider' }",
      'amount' =>  '%.2f' % @donation.amount,
      'description' => "#{ @donation.user.full_name }'s donation to #{@donation.is_organizational ? 'IMPJ' : @donation.rider.full_name}, in the #{RideYear.current.year} ride year."
    }
  end
end



