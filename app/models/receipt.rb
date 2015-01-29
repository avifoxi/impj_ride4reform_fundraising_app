class Receipt < ActiveRecord::Base
  belongs_to :user
  has_one :donor_rider_note

  validates_associated :user, on: :create
  validates :paypal_id, :presence => true
end
