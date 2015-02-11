class RiderYearRegistration < ActiveRecord::Base
  belongs_to :ride_year
  belongs_to :user

  accepts_nested_attributes_for :user

  has_many :donor_rider_notes

  RIDE_OPTIONS = ['Original Track', 'Light Track', 'Hiking', 'Combination Hiking/Riding']

  validate :goal_meets_min_for_ride_year  
  validates_presence_of :agree_to_terms, on: :create, :message => 'You must accept the terms of the ride to register.'
  validates_associated :user, on: :create
  validates_uniqueness_of :user, scope: :ride_year, :message => 'You may only register once per ride year. Have you already registered?'
  validates :ride_option, inclusion: { in: RIDE_OPTIONS }

  before_validation(on: :create) do
    self.ride_year = RideYear.current
  end

  private

  def goal_meets_min_for_ride_year
    unless self.goal >= self.ride_year.min_fundraising_goal
      errors.add :goal, "Your goal must exceed this year's minimum."
    end
  end


end
