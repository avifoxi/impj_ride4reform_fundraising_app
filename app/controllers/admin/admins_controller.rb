class Admin::AdminsController < ApplicationController
	skip_before_action :authenticate_user!
	def index 
		@admins = Admin.all
	end

	def new
		@admin = Admin.new
	end

	def show
		@admin = Admin.find(params[:id])
	end

	def create
		@admin = Admin.new(admin_params)
		if @admin.save! 
			redirect_to admin_admins_path
		else 
			@errors = @admin.errors
			render :edit
		end
	end

# def update 
# 		@ride_year = RideYear.find(params[:id])
# 		if @ride_year.update_attributes(ride_year_params)
# 			redirect_to ride_years_path
# 		else 
# 			@errors = @ride_year.errors
# 			@current = RideYear.current
# 			render :edit
# 		end 
# 	end


	private 

	def admin_params
    params.require(:admin).permit(:username, :email, :password)
  end
end
