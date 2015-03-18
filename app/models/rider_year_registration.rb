class RiderYearRegistration < ActiveRecord::Base
  belongs_to :ride_year
  belongs_to :user

  has_one :registration_payment_receipt, :class_name => 'Receipt', :foreign_key => 'receipt_id'

  delegate :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, to: :user

  has_many :mailing_addresses, through: :user
  accepts_nested_attributes_for :mailing_addresses
  delegate :mailing_addresses, to: :user


  has_one :persistent_rider_profile, through: :user
  accepts_nested_attributes_for :persistent_rider_profile
  delegate :persistent_rider_profile, to: :user

  accepts_nested_attributes_for :user

  has_many :donations

  RIDE_OPTIONS = ['Original Track', 'Light Track', 'Hiking', 'Combination Hiking/Riding']

  validates :goal, numericality: true, presence: true
  validate :goal_meets_min_for_ride_year  
  validates :agree_to_terms, acceptance: { accept: true } 
  validates_associated :user, on: :create
  validates_uniqueness_of :user, scope: :ride_year, :message => 'You may only register once per ride year. Have you already registered?'
  validates :ride_option, inclusion: { in: RIDE_OPTIONS }

  before_validation(on: :create) do
    self.ride_year = RideYear.current
  end

  def percent_of_goal
    return "0" if self.goal <= 0
    
    perc = (self.raised.to_f / self.goal.to_f).round(2) * 100
    perc.to_i.to_s
  end

  private

  def goal_meets_min_for_ride_year
    if self.goal
      unless self.goal >= self.ride_year.min_fundraising_goal
        errors.add :goal, "Your goal must exceed this year's minimum."
      end
    end
  end


end
