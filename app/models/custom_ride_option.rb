class CustomRideOption < ActiveRecord::Base
  belongs_to :ride_year

  validates_presence_of :display_name, :description, :start_date, :end_date, :registration_cutoff, :registration_fee
  validates_associated :ride_year

end
