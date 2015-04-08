class RiderYearRegistration < ActiveRecord::Base
  belongs_to :ride_year
  belongs_to :user

  # registration_payment_receipt
  belongs_to :registration_payment_receipt, :class_name => 'Receipt'

  delegate :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, :email, :full_name, :persistent_rider_profile, to: :user

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

  def raised
    self.donations.where(fee_is_processed: true).sum(:amount)
  end

  def percent_of_goal
    return "0" if self.goal <= 0
    
    perc = (self.raised.to_f / self.goal.to_f).round(2) * 100
    perc.to_i.to_s
  end

  # 'percent_of_goal'.humanize.capitalize
  # def self.to_csv(subset_of_ryrs)
  #   CSV.generate do |csv|
  #     columns = ["full_name", "email", "ride_option", "goal", "raised", "donations count", "percent_of_goal raised"]
  #     csv << columns

  #     subset_of_ryrs.each do |item|
  #       row = [item.full_name,
  #              item.email,
  #              item.ride_option,
  #              item.goal,
  #              item.raised,
  #              item.donations.count,
  #              item.percent_of_goal
  #              ]
  #       csv << row
  #     end
  #   end
  # end


  private

  def goal_meets_min_for_ride_year
    if self.goal
      unless self.goal >= self.ride_year.min_fundraising_goal
        errors.add :goal, "Your goal must exceed this year's minimum."
      end
    end
  end


end
