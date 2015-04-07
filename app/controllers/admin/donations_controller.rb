class Admin::DonationsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def index
		ride_years = RideYear.all
		@donations_by_ride_year = ride_years.map do |r|
			{
				ride_year: r, 
				rider_donations: r.rider_year_registrations.each_with_object([]) {|ryr, arr| arr << ryr.donations }, 
				org_donations: Donation.where(ride_year: r).select{|d| d.}
			}
		end

	end

	def new
		@donation = Donation.new
		@current_riders = RiderYearRegistration.where(ride_year: RideYear.current)
		@donors = User.all
		@donation.build_user
		# @custom_billing_address = MailingAddress.new
	end

	def create
		@donation = Donation.new(full_params.except(:rider_year_registration, :user_id, :user ))

		if full_params[:new_donor] == '0'
			@donation.user = User.find(full_params[:user_id])
		else
			user = User.new(full_params[:user])
			user.title = 'None'
			user.password = Devise.friendly_token.first(8)
			@donation.user = user
		end

		if full_params[:is_organizational] == 'false'
			@donation.rider_year_registration = RiderYearRegistration.find( full_params[:rider_year_registration] )
		end

		if @donation.save 
			redirect_to admin_new_donation_payment_path(@donation)
		else 
			@current_riders = RiderYearRegistration.where(ride_year: RideYear.current)
			@donors = User.all
			@errors = @donation.errors
			@donation.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
			render :new
		end
	end

	def new_donation_payment 
		@donation = Donation.find(params[:id])
		@receipt = @donation.build_receipt
		unless @donation.mailing_addresses.empty?
			@mailing_addresses = @donation.mailing_addresses
		end
		@custom_billing_address = MailingAddress.new
		@donor = @donation.user
		if @donation.rider_year_registration
			@rider = @donation.rider_year_registration
		end
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
			if @receipt && @receipt.errors
				@receipt.errors.each do |k,v|
					@errors.messages[k.to_sym] = [v]
				end
			end
			render json: {
				errors: @errors.full_messages.to_sentence
			} 
			return
		end
		
		unless paying_by_check
			@donation.user.cc_type = cc_info['type']
			@donation.user.cc_number = cc_info['number']
			@donation.user.cc_cvv2 = cc_info['cvv2']
			unless @donation.user.valid?
				re_render_new_dp_w_errors
				return
			end
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

		if paying_by_check
			
			@receipt = Receipt.new({ 
				user: @donation.user, amount: @donation.amount
			}.merge( full_params[:receipt] ))
			unless @receipt.save
				# @donation.errors.add(:payment, ppp.payment.error)
				re_render_new_dp_w_errors
				return
			end
		else # process credit card
			ppp = PaypalPaymentPreparer.new({
				user: @donation.user,
				cc_info: cc_info, 
				billing_address: billing_address,
				transaction_details: transaction_details
			})

			if ppp.create_payment
				@receipt = Receipt.create(user: @donation.user, amount: @donation.amount, paypal_id: ppp.payment.id, full_paypal_hash: ppp.payment.to_json)
			else
				@donation.errors.add(:payment, ppp.payment.error)
				re_render_new_dp_w_errors
			end
		end
		# p '$'*80
		# p '@receipt'
		# p "#{@receipt.inspect}"
		# p 'valid?'
		# p "#{@receipt.valid?}"
		# p 'errors'
		# p "#{@receipt.errors.inspect}"
		# p '#'*80
		# p 'passed the receipt creation w check'
		@donation.update_attributes(receipt: @receipt, fee_is_processed: true)	
		DonationMailer.successful_donation_thank_donor(@donation).deliver
		
		unless @donation.is_organizational
			rider = @donation.rider.persistent_rider_profile
			DonationMailer.successful_donation_alert_rider(@donation).deliver
		end
		render json: {
			success: 'no errors what?',
			redirect_address: admin_donation_url(@donation)
		} 
	end

	def show
		@donation = Donation.find(params[:id])
		@receipt = @donation.receipt
		@donor = @donation.user
		if @donation.rider_year_registration
			@rider = @donation.rider_year_registration
		end
	end

	private

	def full_params
    params.require(:donation).permit(:amount, :anonymous_to_public, :note_to_rider, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses, :is_organizational, :rider_year_registration, :new_donor, :user_id,
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
    	], 
    	:receipt => [
    		:by_check,
				:check_num,
				:bank,
				:check_dated
    	]  
    )
  end
  # "{\"amount\"=>\"890\", \"anonymous_to_public\"=>\"0\", \"note_to_rider\"=>\"feep\", \"is_organizational\"=>\"false\", \"rider_year_registration\"=>\"22\", \"new_donor\"=>\"0\", \"user_id\"=>\"1\", \"user\"=>{\"first_name\"=>\"\", \"last_name\"=>\"\", \"email\"=>\"\"}}"

  def paying_by_check
  	full_params[:receipt][:by_check] == "1"
  end

  # def donor
  # 	if full_params[:new_donor] == '0'

  # 	else

  # 	end
  # end

  def transaction_details
    {
      'name' => "user donation to #{@donation.is_organizational ? 'IMPJ' : 'rider' }",
      'amount' =>  '%.2f' % @donation.amount,
      'description' => "#{ @donation.user.full_name }'s donation to #{@donation.is_organizational ? 'IMPJ' : @donation.rider.full_name}, in the #{RideYear.current.year} ride year."
    }
  end

end
