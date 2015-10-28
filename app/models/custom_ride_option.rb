class CustomRideOption < ActiveRecord::Base
  belongs_to :ride_year
  has_many :rider_year_registrations, through: :ride_year

  validates_presence_of :display_name, :start_date, :end_date, :registration_cutoff, :registration_fee
  validates_associated :ride_year

  def correct_discount_code?( resource )
  	resource.discount_code == self.discount_code
  end

  def registered_riders
  	self.rider_year_registrations.where(ride_option: self.display_name)
  end
end
