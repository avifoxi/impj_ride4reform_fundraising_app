class UsersController < ApplicationController
	skip_before_action :authenticate_admin!, :authenticate_user!

	before_action :redirect_if_public_site_is_not_active

	def new 
		@user = User.new
	end

end
