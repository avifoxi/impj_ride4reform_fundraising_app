class DonationsController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!

	def new
		@rider = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@donation = Donation.new
		@donation.build_user
	end

	def create

		@rider = PersistentRiderProfile.find(params[:persistent_rider_profile_id])		
		@donation = Donation.new(full_params.except(:user))

		def error_n_render
			@donation.user = @user
			@donation.valid?
			@errors = @donation.errors
			@donation.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
			render 'new'
		end

		@user = User.find_by(email: full_params[:user][:email])
		unless @user
			@user = User.new(full_params[:user])
			@user.title = 'None'
			@user.password = Devise.friendly_token.first(8)
			unless @user.save
				error_n_render
				return
			end
		end

		@donation.rider_year_registration = @rider.current_registration
		@donation.user = @user

		if @donation.save 
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
			if @custom_billing_address.errors 
				@custom_billing_address.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			unless @donation.mailing_addresses.empty?
				@mailing_addresses = @donation.mailing_addresses
			end	
			@custom_billing_address = @custom_billing_address || MailingAddress.new
			render :new_donation_payment
		end
		
		unless cc_info
			@payment_errors = ['Please enter your full credit card information to complete your registration']
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
			rider = @donation.rider.persistent_rider_profile
			flash[:notice] = "Thank you for donating!"
			redirect_to persistent_rider_profile_path(rider)
		else
			@payment_errors = ppp.payment.error
			re_render_new_dp_w_errors
		end
	end

	private

	def full_params
    params.require(:donation).permit(:amount, :anonymous_to_public, :note_to_rider, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses,
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
      'name' => "user donation to rider",
      'amount' =>  '%.2f' % @donation.amount,
      'description' => "#{ @donation.user.full_name }'s donation to #{@donation.rider.full_name}, in the #{RideYear.current.year} ride year."
    }
  end
end



