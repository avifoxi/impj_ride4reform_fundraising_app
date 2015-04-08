class Admin::RiderYearRegistrationsController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	# /admin/ride_years/:ride_year_id/rider_year_registrations
	# /admin/rider_year_registrations
	def index
		@ride_year = params[:ride_year_id] ? RideYear.find(params[:ride_year_id]) : RideYear.current
		@all_ride_years = RideYear.all
		@ryrs = @ride_year.rider_year_registrations
		@avg_raised = (@ryrs.map{|r| r.raised}.inject{|sum, n| sum + n}.to_f / @ryrs.count).to_i  
		@avg_perc = (@ryrs.map{|r| r.percent_of_goal.to_i}.inject{|sum, n| sum + n}.to_f / @ryrs.count).to_i  
		@total_raised = @ride_year.donations.where("fee_is_processed = ?", true).sum(:amount)
	end

  # CSV.generate do |csv|
  #   columns = ["id", "ride_year", "ride_option", "paid",
  #              "accept_terms", "goal", "raised", "rider",
  #              "birthday", "email", "phone1", "phone2",
  #              "address1", "address2", "city", "state",
  #              "zip", "bio", "date"]
  #   csv << columns

  #   all.each do |item|
  #     row = [item.id,
  #            item.ride_year,
  #            item.ride_option,
  #            item.paid,
  #            item.accept_terms,
  #            item.goal,
  #            item.raised,
  #            item.rider.full_name,
  #            item.birthdate,
  #            item.rider.email,
  #            item.primary_phone,
  #            item.secondary_phone,
  #            item.mailing_address.line1,
  #            item.mailing_address.line2,
  #            item.mailing_address.city,
  #            item.mailing_address.state,
  #            item.mailing_address.zip,
  #            item.bio,
  #            item.created_at]
  #     csv << row
  #   end
  # end

end
