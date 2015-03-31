class StaticPagesController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!


	# def home_page
	# end

	def home_page
		# render layout: "home_page_hero"
	end

	def donors
		@donors = Donation.all.select {|d| !d.anonymous_to_public }.map {|d| d.user}.uniq!.sort_by! { |a| a.last_name }
	end
end
