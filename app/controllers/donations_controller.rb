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

		## TODO -- the error handling should maybe be a rescue? so as not to repeat the SAME code for error renders at different stages of @donation + @user instantiation
		@user = User.find_by(email: full_params[:user][:email])
		unless @user
			@user = User.new(full_params[:user])
			@user.title = 'None'
			@user.password = Devise.friendly_token.first(8)
			unless @user.save
				@donation.user = @user
				@donation.valid?
				@errors = @donation.errors
				@donation.user.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
				render 'new'
				return
			end
		end

		@donation.rider_year_registration = @rider.current_registration
		@donation.user = @user

		if @donation.valid? 
			@donation.save
			redirect_to new_donation_payment_path(@donation)
		else
			@errors = @donation.errors
			if @donation.user.errors 
				@donation.user.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			render 'new'
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

		unless cc_info
			@payment_errors = ['Please enter your full credit card information to complete your registration']
			unless @donation.mailing_addresses.empty?
				@mailing_addresses = @donation.mailing_addresses
			end			
			@custom_billing_address = MailingAddress.new
			render :new_donation_payment
			return
		end

		if full_params['custom_billing_address'] == '1'
			@custom_billing_address = MailingAddress.new(custom_billing_address)
			@custom_billing_address.user = @donation.user
			unless @custom_billing_address.save
				@errors = @custom_billing_address.errors
				@mailing_addresses = @ryr.mailing_addresses
				render :new_pay_reg_fee
				return
			end
			billing_address = @custom_billing_address
		else
			billing_address = MailingAddress.find(full_params['mailing_address_ids'])
		end

		ppp = PaypalPaymentPreparer.new({
			user: @donation.user,
			cc_info: cc_info, 
			billing_address: billing_address,
			transaction_details: transaction_details
		})


		if ppp.create_payment
			Receipt.create(user: current_user, amount: current_fee, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)

			@rider = current_user.persistent_rider_profile
			flash[:notice] = "Thank you for registering to ride!"
			redirect_to persistent_rider_profile_path(@rider)
		else
			@payment_errors = ppp.payment.error
			@mailing_addresses = @ryr.mailing_addresses
			unless @custom_billing_address
				@custom_billing_address = MailingAddress.new
			end
			@registration_fee = current_fee

			render :new_pay_reg_fee
		end
	end



	# from rider_reg_controller
	# def create_pay_reg_fee

	# 	@ryr = RiderYearRegistration.find(params[:ryr_id])

	# 	unless cc_info

	# 		@payment_errors = ['Please enter your full credit card information to complete your registration']
	# 		@mailing_addresses = @ryr.mailing_addresses
	# 		@custom_billing_address = MailingAddress.new
	# 		@registration_fee = current_fee
	# 		render :new_pay_reg_fee
	# 		return
	# 	end

	# 	if full_params['custom_billing_address'] == '1'
	# 		@custom_billing_address = MailingAddress.new(custom_billing_address)
	# 		@custom_billing_address.user = current_user
	# 		unless @custom_billing_address.save
	# 			@errors = @custom_billing_address.errors
	# 			@mailing_addresses = @ryr.mailing_addresses
	# 			render :new_pay_reg_fee
	# 			return
	# 		end
	# 		billing_address = @custom_billing_address
	# 	else
	# 		billing_address = MailingAddress.find(full_params['mailing_address_ids'])
	# 	end
	
	# 	ppp = PaypalPaymentPreparer.new({
	# 		user: current_user,
	# 		cc_info: cc_info, 
	# 		billing_address: billing_address,
	# 		transaction_details: transaction_details
	# 	})

	# 	if ppp.create_payment
	# 		Receipt.create(user: current_user, amount: current_fee, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)

	# 		@rider = current_user.persistent_rider_profile
	# 		flash[:notice] = "Thank you for registering to ride!"
	# 		redirect_to persistent_rider_profile_path(@rider)
	# 	else
	# 		@payment_errors = ppp.payment.error
	# 		@mailing_addresses = @ryr.mailing_addresses
	# 		unless @custom_billing_address
	# 			@custom_billing_address = MailingAddress.new
	# 		end
	# 		@registration_fee = current_fee

	# 		render :new_pay_reg_fee
	# 	end
	# end




	private

	def full_params
    params.require(:donation).permit(:amount, :visible_to_public, :note_to_rider, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_address_ids,
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
    		],
    	:user => [
    		:first_name, :last_name, :email
    	] 
    )
  end

  def cc_info

  end
end



