class Donation < ActiveRecord::Base
  belongs_to :rider_year_registration
  has_one :rider, through: :rider_year_registration, source: :user

  belongs_to :ride_year

  belongs_to :receipt
  # has_one :donor, through: :receipt, source: :user

  belongs_to :user

  delegate :mailing_addresses, :email, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, to: :user

  validates_associated :user, on: :create

  validates_presence_of :user
  validates_presence_of :rider_year_registration, :unless => :is_organizational
  validates_presence_of :amount

  attr_accessor :new_donor, :pay_with_check

  before_create :associate_to_current_ride_year

  def donor_name
    self.user.full_name
  end

  def recipient_name
    if self.rider_year_registration
      self.rider_year_registration.full_name
    else
      'IMPJ'
    end
  end

  private

  def associate_to_current_ride_year
    if self.is_organizational
      self.ride_year = RideYear.current 
    else 
      self.ride_year = self.rider_year_registration.ride_year
    end
  end
end

# to_kill
# [347, 432, 402, 199, 408, 293, 287, 314, 377, 350, 392, 87, 383, 400, 394, 311, 278, 279, 280, 281, 155, 145, 127, 141, 170, 147, 59, 132, 157, 171]


