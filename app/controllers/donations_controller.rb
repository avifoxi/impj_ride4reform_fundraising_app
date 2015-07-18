class DonationsController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!

	before_action :redirect_if_public_site_is_not_active
	
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

		pm = PaymentMaker.new(@donation, :donation, full_params)

		begin
			@receipt_or_errors = pm.process_payment
		rescue
			render json: {
				errors: "We're very sorry, but there was an error connecting to PayPal."
			}
			return  
		end
	
		if @receipt_or_errors.instance_of?(Receipt)
			@donation.update_attributes(fee_is_processed: true)	
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
			render json: @receipt_or_errors
		end
	end

	def edit
		@donation = Donation.find(params[:id])

		if @donation.receipt
			flash[:alert] = 'This donation has already been processed, and cannot be edited here. For help contact IMPJ.' 
			redirect_to root_url
			return
		end

		@user = @donation.user
		@rider = @donation.rider
	end

	def update
		@donation = Donation.find(params[:id])
		if @donation.update_attributes(full_params)
			redirect_to new_donation_payment_path(@donation)
		else
			@errors = @donation.errrors
			render :edit
		end
	end

	def destroy
		@donation = Donation.find(params[:id])
		if @donation.receipt
			flash[:alert] = 'This donation has already been processed, and cannot be deleted here. For help contact IMPJ.' 
			redirect_to root_url
			return
		end 
		@donation.destroy
		flash[:notice] = 'Successfully deleted donation.'
		redirect_to root_url
	end

	def index
		@prp = PersistentRiderProfile.find(params[:persistent_rider_profile_id])
		@donations = @prp.rider_year_registrations.inject([]){|arr, ryr| arr << ryr.donations}.flatten
		@current_donations = @donations.select{|d| d.ride_year == RideYear.current}
		@donations -= @current_donations
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

end



