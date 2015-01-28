class User < ActiveRecord::Base
	has_many :mailing_addresses

	has_one :persistent_rider_profile

	has_many :rider_year_registrations
	has_many :receipts
end
