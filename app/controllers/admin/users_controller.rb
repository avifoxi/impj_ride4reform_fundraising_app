class Admin::UsersController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	def index 
		@users =  User.all.order(:last_name)
		respond_to do |format|
      format.html 
      format.csv { 
      	send_data gen_csv(@users, [:full_name, :email, :years_ridden, :total_raised, :total_donations_received, :total_donations_given, :total_amount_donated])  
      	response.headers['Content-Disposition'] = 'attachment; filename="' + "all_current_users_#{Time.now.strftime("%Y_%m_%d_%H%M")}" + '.csv"'
      }
    end
	end

	def show
		@user = User.find(params[:id])
		if @user.persistent_rider_profile
			@prp = @user.persistent_rider_profile
			@all_rides = @user.rider_year_registrations
			if @user.rider_year_registrations.find_by(ride_year: RideYear.current)
				@current_ryr = @user.rider_year_registrations.find_by(ride_year: RideYear.current)
			end
		end
		unless @user.donations.empty?
			@donations = @user.donations
		end
		if @user.mailing_addresses
			@mailing_addresses = @user.mailing_addresses
		end 
	end

	def edit
		@user = User.find(params[:id])
		if @user.persistent_rider_profile
			@prp = @user.persistent_rider_profile
		end
	end

	def update
				p '$'*80
		p 'admin_user_params b'
		p "#{admin_user_params.inspect}"

		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to admin_user_path(@user)
		else 
			@errors = @user.errors
			render 'edit'
		end
	end 

	# "{\"utf8\"=>\"✓\", \"_method\"=>\"put\", \"authenticity_token\"=>\"cdEC3bWxuiIncbBZcYM+n+hLJKkPCdNfsmRT7+kXTCE=\", \"user\"=>{\"title\"=>\"Dr\", \"first_name\"=>\"Avi\", \"last_name\"=>\"Rider\", \"email\"=>\"a@a.com\", \"persistent_rider_profile\"=>{\"bio\"=>\"Try to hack the RSS array, maybe it will connect the back-end alarm!\", \"birthdate(1i)\"=>\"1967\", \"birthdate(2i)\"=>\"12\", \"birthdate(3i)\"=>\"16\", \"primary_phone\"=>\"1234567890\", \"secondary_phone\"=>\"\"}}, \"commit\"=>\"Update User\", \"action\"=>\"update\", \"controller\"=>\"admin/users\", \"id\"=>\"1\"}"

	private

	def full_params
		params.require(:user).permit(:first_name, :title, :last_name, :email,
			:persistent_rider_profile => [
  			:primary_phone, :secondary_phone, :avatar, :birthdate, :bio
  		] 
		)
	end

	def user_params
		full_params.except(:persistent_rider_profile)
	end
	
	def prp_params
		full_params[:persistent_rider_profile]
	end
end
