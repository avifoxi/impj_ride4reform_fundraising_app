class Admin::DonationsController < ApplicationController
	skip_before_action :authenticate_user!
	layout "admins"

	def new
		
	end

end
