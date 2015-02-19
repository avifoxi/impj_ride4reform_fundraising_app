class PersistentRiderProfile < ActiveRecord::Base
	belongs_to :user
	has_many :rider_year_registrations, through: :user

	validates_associated :user, on: :create
	validate :has_at_least_one_rider_year_registration

	## this is stand in method for paperclip -- get routes up first before addin photo saves + stuff
	attr_accessor :photo_upload

	private

	def has_at_least_one_rider_year_registration
		unless self.user.rider_year_registrations.count >= 1
      errors.add :rider_year_registrations, "You must be registered for at least one ride to have a persistent profile."
    end
	end
	
end
