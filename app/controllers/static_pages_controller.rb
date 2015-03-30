class StaticPagesController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!


	# def home_page
	# end

	def home_page
		render layout: "home_page_hero"
	end
end
