class Admin::DonationsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def new
		@donation = Donation.new
		@current_riders = RiderYearRegistration.where(ride_year: RideYear.current)
		@donors = User.all
		@donation.build_user
		# @custom_billing_address = MailingAddress.new
	end

	def create
		# p '$'*80
		# p 'params'
		# p "#{params.inspect}"

		# p '$'*80
		# p 'full_params'
		# p "#{full_params.inspect}"

		@donation = Donation.new(full_params.except(:rider_year_registration, :user_id, :user ))

		## assign donor
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

		p '$'*80
		p '@donation'
		p "#{@donation.inspect}"

		if @donation.save 
			redirect_to new_donation_payment_path(@donation)
		else 
			@errors = @donation.errors
			@donation.user.errors.each do |k,v|
				@errors.messages[k.to_sym] = [v]
			end
			render :new
		end
		
 
	end

	def new_donation_payment 

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
    	]  
    )
  end
  # "{\"amount\"=>\"890\", \"anonymous_to_public\"=>\"0\", \"note_to_rider\"=>\"feep\", \"is_organizational\"=>\"false\", \"rider_year_registration\"=>\"22\", \"new_donor\"=>\"0\", \"user_id\"=>\"1\", \"user\"=>{\"first_name\"=>\"\", \"last_name\"=>\"\", \"email\"=>\"\"}}"

  def new_don_params

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
