class Admin::AdminsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"
	
	def index 
		@admins = Admin.all
	end

	def new
		@admin = Admin.new
		# render "#{Rails.root}/app/views/admins/registrations/new"
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

	def destroy
		if Admin.count > 1
			@admin = Admin.find(params[:id])
			@admin.destroy
			notice = "Admin successfully deleted."
		else
			notice = "Please create another valid admin before deleting."
		end
		flash[:notice] = notice
		redirect_to admin_path
	end

	private 

	def admin_params
    params.require(:admin).permit(:username, :email, :password, :password_confirmation, :email_confirmation)
  end
end
