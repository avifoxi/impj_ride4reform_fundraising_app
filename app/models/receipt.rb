class Receipt < ActiveRecord::Base
  belongs_to :user
  has_one :donation

  # alias seems to work
  has_one :rider_year_registration, :foreign_key => "registration_payment_receipt_id"

  validates_associated :user, on: :create
  validates_presence_of :user, :amount

  validates_presence_of :paypal_id, unless: :by_check

  validates_presence_of :check_num, :bank, :check_dated, if: :by_check
end
