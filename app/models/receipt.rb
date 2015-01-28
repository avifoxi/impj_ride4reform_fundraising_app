class Receipt < ActiveRecord::Base
  belongs_to :user
  has_one :donation_spec
end
