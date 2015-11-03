class StaticPagesController < ApplicationController
	skip_before_action :authenticate_admin!
	skip_before_action :authenticate_user!

	def site_is_not_active
	end

	def home_page
	end

	def donors
		if Donation.count > 2
			@donors = Donation.all.select {|d| !d.anonymous_to_public }.map {|d| d.user}.uniq!.sort_by! { |a| a.last_name }
		else
			@donors = []
		end
	end
end
