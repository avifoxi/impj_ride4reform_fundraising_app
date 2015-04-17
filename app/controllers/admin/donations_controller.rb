class Admin::DonationsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	def index
		# Donation.last.call_worker_call_mailer
		@current_ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@donations = @current_ride_year.donations
		
		respond_to do |format|
      format.html {
      	@ride_years = RideYear.all.order(created_at: :desc)
      }
      format.csv { 
      	send_data gen_csv(@donations, [:id, :donor_name, :recipient_name, :amount, :created_at])  
      	response.headers['Content-Disposition'] = 'attachment; filename="' + "donations_stats_#{Time.now.strftime("%Y_%m_%d_%H%M")}" + '.csv"'
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
		p '#'*80
		p 'params'
		p "#{params.inspect}"
		p '#'*80
		p 'fullparams'
		p "#{full_params.inspect}"
		@donation = Donation.new(full_params.except(:rider_year_registration, :user_id, :user ))

		p '#'*80
		p '@donation'
		p "#{@donation.inspect}"
		
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
		pm = PaymentMaker.new(@donation, :donation, full_params, current_admin)

		receipt_or_errors = pm.process_payment
		
		if receipt_or_errors.instance_of?(Receipt)
			@donation.update_attributes(fee_is_processed: true)
			# @donation.call_worker_call_mailer

						# DonationMailerWorker.new.perform(@donation.id)	

						p '#'*80
						p 'rails env'
						p "#{Rails.env}"

						DonationMailerWorker.perform_async(@donation.id)	
			# DonationMailer.delay.successful_donation_thank_donor(@donation.id)
			
			# unless @donation.is_organizational
			# 	rider = @donation.rider.persistent_rider_profile
			# 	DonationMailer.successful_donation_alert_rider(@donation).deliver
			# end
			render json: {
				success: 'no errors what?',
				redirect_address: admin_donation_url(@donation)
			} 
		else
			render json: receipt_or_errors
		end
	end

	def show
		@donation = Donation.find(params[:id])
		@receipt = @donation.receipt
		@donor = @donation.user
		if @donation.rider_year_registration
			@rider = @donation.rider_year_registration
		end
	end

	def edit
		@donation = Donation.find(params[:id])

		if @donation.receipt
			flash[:alert] = 'This donation has already been processed, and cannot be edited.' 
			redirect_to admin_path
			return
		end

		@user = @donation.user
		@rider = @donation.rider
	end

	def update
		@donation = Donation.find(params[:id])
		if @donation.update_attributes(full_params)
			redirect_to admin_new_donation_payment_path(@donation)
		else
			@errors = @donation.errrors
			render :edit
		end
	end

	def destroy
		@donation = Donation.find(params[:id])
		if @donation.receipt
			flash[:alert] = 'This donation has already been processed, and cannot be deleted.' 
			redirect_to root_url
			return
		end 
		@donation.destroy
		flash[:notice] = 'Successfully deleted donation.'
		redirect_to admin_path
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
  
end
