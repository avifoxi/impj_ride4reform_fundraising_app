class RideYear < ActiveRecord::Base

  has_many :rider_year_registrations
  has_many :donations
  has_many :custom_ride_options
  
  attr_accessor :set_current_in_form

  validates_presence_of :registration_fee, :registration_fee_early, :min_fundraising_goal, :year, :ride_start_date, :ride_end_date, :early_bird_cutoff
  validates_numericality_of :registration_fee, :registration_fee_early, :min_fundraising_goal, :year

  OPTIONS = ['Original Track', 'Light Track'
    # , 
    # 'Hiking', 
    # 'Combination Hiking/Riding'
  ]

	def self.current
  	max = RideYear.maximum(:current)
  	RideYear.find_by(current: max)
  end

  def options
    if self.custom_ride_options
      OPTIONS + self.custom_ride_options.map{ |o| o.display_name }
    else
      OPTIONS
    end
  end

  def avg_raised_by_rider
    ryrs = self.rider_year_registrations
    (ryrs.map{|r| r.raised}.inject{|sum, n| sum + n}.to_f / ryrs.count).to_i 
  end 

  def avg_perc_of_rider_goal_met
    ryrs = self.rider_year_registrations
    (ryrs.map{|r| r.percent_of_goal.to_i}.inject{|sum, n| sum + n}.to_f / ryrs.count).to_i  
  end

  def total_raised
    self.donations.where("fee_is_processed = ?", true).sum(:amount)
  end


  def set_as_current
  	max = RideYear.maximum(:current)
  	self.update_attributes(current: max + 1)
  end

  def self.current_fee 
    current = RideYear.current
    if Date.today < current.early_bird_cutoff
      current.registration_fee_early
    else
      current.registration_fee
    end
  end


end
