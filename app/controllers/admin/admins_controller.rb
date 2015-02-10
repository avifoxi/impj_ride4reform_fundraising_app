class Admin::AdminsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"
	
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
		if @admin.save 
			redirect_to admin_admins_path
		else 
			@errors = @admin.errors
			render :new
		end
	end

	private 

	def admin_params
    params.require(:admin).permit(:username, :email, :password)
  end
end
