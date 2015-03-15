class Donation < ActiveRecord::Base
  belongs_to :rider_year_registration
  has_one :rider, through: :rider_year_registration, source: :user

  belongs_to :receipt
  # has_one :donor, through: :receipt, source: :user

  belongs_to :user

  delegate :mailing_addresses, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2, :custom_billing_address, to: :user


  # validates_associated :receipt, on: :create
  validates_associated :rider_year_registration, on: :create
end
