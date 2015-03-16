class DonationsController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!

	def new
		@rider = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@donation = Donation.new
		@donation.build_user
	end

	def create
		p '#'*80
		p 'these is params'
		p "#{params.inspect}"
		p '#'*80
		@persistent_rider_profile = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@donation = Donation.new(full_params.except(:user))

		p '#'*80
		p '@donation'
		p "#{@donation.inspect}"
		p '#'*80

		@user = User.find_by(email: full_params[:user][:email])
		if @user
			@mailing_addresses = @user.mailing_addresses
		else
			@user = User.new(full_params[:user])
			@user.password = Devise.friendly_token.first(8)
			unless @user.save
				@errors = @user.errors
				@donation.valid?
				if @donation.errors
					@errors << @donation.errors
				end
				render 'new'
			end
		end

		@custom_billing_address = MailingAddress.new
		@donation.rider_year_registration = @persistent_rider_profile.current_registration

		if @donation.valid? 
			@donation.save
			

		# p '#'*80
		# p 'these is params'
		# p "#{params.inspect}"
		# p '#'*80
		# @mailing_addresses
		# @custom_billing_address

		# redirect_to :new_pay_donation

	end


	# from ryr controller -- all necessary details for new payment
	# def new_pay_reg_fee
	# 	@ryr = RiderYearRegistration.find(params[:rider_year_registration])
	# 	@mailing_addresses = @ryr.mailing_addresses
	# 	@custom_billing_address = MailingAddress.new
	# 	@registration_fee = current_fee
	# end


	private

# 	"these is params"
# "{\"utf8\"=>\"✓\", \"authenticity_token\"=>\"HBvxNz1A1CwfbP8ZtCPTkz95ICqUG/bqdIG+FAAP1Xw=\", \"

# 	donation\"=>
# 		{\"amount\"=>\"430\", \"note_to_rider\"=>\"foo ba da\", 
# 			\"user\"=>
# 				{\"first_name\"=>\"avi\", \"last_name\"=>\"alsdkfj\", \"email\"=>\"a@a.com\"}, 
# 			\"visible_to_public\"=>\"1\"
# 		}, 
# 		\"commit\"=>\"Create Donation\", \"action\"=>\"create\", \"controller\"=>\"donations\", \"
# 		persistent_rider_profile_id\"=>\"1\"}"

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
end
