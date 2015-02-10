class Admin::UsersController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def index 
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end
end
