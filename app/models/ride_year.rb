class RideYear < ActiveRecord::Base

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
