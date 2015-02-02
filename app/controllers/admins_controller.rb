class AdminsController < ApplicationController
	skip_before_action :authenticate_user!
	def index 
		@admins = Admin.all
	end
end
