class CustomRideOption < ActiveRecord::Base
  belongs_to :ride_year
  has_many :rider_year_registrations

  validates_presence_of :display_name, :description, :start_date, :end_date, :registration_cutoff, :registration_fee, :discount_code, :liability_text
  validates_associated :ride_year

  def correct_discount_code?( resource )
  	resource.discount_code == self.discount_code
  end
end
