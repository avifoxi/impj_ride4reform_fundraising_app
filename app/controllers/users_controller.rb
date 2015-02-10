class UsersController < ApplicationController
	skip_before_action :authenticate_admin!
	def new 
		@user = User.new
	end


end
