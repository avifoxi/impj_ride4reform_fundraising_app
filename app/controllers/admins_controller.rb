class AdminsController < ApplicationController
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
		## TODO getting error uninitialized constant Admins on this action... which is odd. b/c we have fine results with other actions
	end

	private 

	def admin_params
    params.require(:admin).permit(:username, :email, :password)
  end
end
