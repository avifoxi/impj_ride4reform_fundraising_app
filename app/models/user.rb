class User < ActiveRecord::Base
	has_many :mailing_addresses

	has_one :persistent_rider_profile

	has_many :rider_year_registrations
	has_many :receipts

	def set_new_primary_address(mailing_address)
    max = self.mailing_addresses.map{|m| m.users_primary}.max
    mailing_address.update_attributes(users_primary: max + 1)
  end

  def primary_address
  	self.mailing_addresses.max_by{|m| m.users_primary}
  end

end
