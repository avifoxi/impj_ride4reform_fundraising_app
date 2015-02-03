class RideYear < ActiveRecord::Base

  attr_accessor :set_current_in_form

  validates_presence_of :registration_fee, :registration_fee_early, :min_fundraising_goal, :year, :ride_start_date, :ride_end_date, :early_bird_cutoff
  validates_numericality_of :registration_fee, :registration_fee_early, :min_fundraising_goal, :year

	def self.current
  	max = RideYear.maximum(:current)
  	RideYear.find_by(current: max)
  end

  # def self.current_fee
  # 	current = RideYear.current
  # 	if Time.now < current.early_bird_cutoff
  # 		current.registration_fee_early
  # 	else
  # 		current.registration_fee
  # 	end
  # end

  def set_as_current
  	max = RideYear.maximum(:current)
  	self.update_attributes(current: max + 1)
  end

end
