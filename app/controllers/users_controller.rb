class UsersController < ApplicationController
	skip_before_action :authenticate_admin!, :authenticate_user!

	def new 
		@user = User.new
	end

end
