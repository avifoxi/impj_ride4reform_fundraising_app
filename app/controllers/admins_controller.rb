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
		p "$"*80
		puts "PARAMS:"
		p params
	end

	private 

	def admin_params
    params.require(:admin).permit(:username, :email, :password)
  end
end
