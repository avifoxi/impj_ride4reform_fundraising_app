class Receipt < ActiveRecord::Base
  belongs_to :user
  has_one :donation

  # alias seems to work
  has_one :rider_year_registration, :foreign_key => "registration_payment_receipt_id"

  validates_associated :user, on: :create
  validates_presence_of :paypal_id, :user
end
