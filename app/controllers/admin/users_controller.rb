class Admin::UsersController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	include CSVMaker

	def index 
		@users =  User.all.order(:last_name)
		respond_to do |format|
      format.html {
      	@user = User.new
      }
      format.csv { 
      	send_data gen_csv(@users, [:full_name, :email, :primary_address, :years_ridden, :total_raised, :total_donations_received, :total_donations_given, :total_amount_donated])  
      	response.headers['Content-Disposition'] = 'attachment; filename="' + "all_current_users_#{Time.now.strftime("%Y_%m_%d_%H%M")}" + '.csv"'
      }
    end
	end

	def show
		@user = User.find(params[:id])
		@current_ride_year = RideYear.current
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
		@user = User.find(params[:id])
		@prp = @user.persistent_rider_profile
		if @user.update_attributes(user_params)
			if (@prp == nil) || ( @prp && @prp.update_attributes(prp_params) )
				flash[:notice] = 'Changes successfully made'
				redirect_to admin_user_path(@user)
				return
			end
		end
		@errors = @user.errors
		render 'edit'
	end 

	def create
		@existing_user = User.find_by(email: full_params[:email])
		if @existing_user 
			flash[:notice] = 'User already in system'
			redirect_to admin_user_path(@existing_user)
			return
		end
		@user = User.new(full_params.merge!(password: Devise.friendly_token.first(8) ))
		if @user.save
			redirect_to new_admin_user_rider_year_registration_path(@user)
		else
			@users = User.all
			render :index
		end
	end

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
