class Admin::RiderYearRegistrationsController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	# /admin/ride_years/:ride_year_id/rider_year_registrations
	# /admin/rider_year_registrations
	def index
		@ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@ryrs = @ride_year.rider_year_registrations
	
		respond_to do |format|
      format.html {
      	@all_ride_years = RideYear.all
      	unless @ryrs.empty?
	      	@avg_raised = @ride_year.avg_raised_by_rider
					@avg_perc = @ride_year.avg_perc_of_rider_goal_met  
					@total_raised = @ride_year.total_raised
				end
      }
      format.csv { 
      	send_data gen_csv(@ryrs, [:full_name, :ride_option, :goal, :raised, :percent_of_goal])  
      	response.headers['Content-Disposition'] = 'attachment; filename="' + "registered_rider_stats_#{Time.now.strftime("%Y_%m_%d_%H%M")}" + '.csv"'
      }
    end
	end

	def new
		@user = User.find(params[:user_id])
		@ryr = @user.rider_year_registrations.build
		@receipt = @ryr.build_registration_payment_receipt
		@mailing_addresses = @ryr.mailing_addresses
		@custom_billing_address = MailingAddress.new
	end

	def create
		@user = User.find(params[:user_id])
		@ryr = @user.rider_year_registrations.build(ryr_params)
		

		pm = PaymentMaker.new(@ryr, :registration, full_params, current_admin)
		receipt_or_errors = pm.process_payment
	
		if receipt_or_errors.instance_of?(Receipt)
			@ryr.update_attributes(registration_payment_receipt: receipt_or_errors )
			RiderYearRegistrationsMailer.successful_registration_welcome_rider(@ryr).deliver
			render json: {
				success: 'no errors what?',
				redirect_address: admin_user_url(@user)
			} 
		else
			render json: receipt_or_errors
		end

	end

	private

	def full_params
    params.require(:rider_year_registration).permit(:ride_option, :goal, :agree_to_terms, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :mailing_addresses,
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
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

  def ryr_params
  	full_params.slice(:ride_option, :goal)
  end
end
