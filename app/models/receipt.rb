class Receipt < ActiveRecord::Base
  belongs_to :user
  has_one :donation_spec

  validates_associated :user, on: :create
  validates :paypal_id, :presence => true
end
