class PersistentRiderProfile < ActiveRecord::Base
	belongs_to :user
	has_many :rider_year_registrations, through: :user

	validates_associated :user, on: :create
	validate :has_at_least_one_rider_year_registration

	private

	def has_at_least_one_rider_year_registration
		unless self.rider_year_registrations.count >= 1
      errors.add :rider_year_registrations, "Your must be registered for at least one ride to have a persistent profile."
    end
	end
	
end
