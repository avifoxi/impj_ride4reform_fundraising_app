class PersistentRiderProfile < ActiveRecord::Base
	belongs_to :user
	has_many :rider_year_registrations, through: :user

	validates_associated :user, on: :create
	validate :has_at_least_one_rider_year_registration

	validates_presence_of :primary_phone, length: {is: 10}
	validates_length_of :secondary_phone, is: 10, :allow_blank => true
	validate :is_within_accepted_age_range 

	## this is stand in method for paperclip -- get routes up first before addin photo saves + stuff
	attr_accessor :photo_upload

	private

	def has_at_least_one_rider_year_registration
		unless self.user.rider_year_registrations.count >= 1
      errors.add :rider_year_registrations, "You must be registered for at least one ride to have a persistent profile."
    end
	end

	def is_within_accepted_age_range
		unless self.birthdate > 17.years.ago && self.birthdate < 80.years.ago
			errors.add :birthdate, "You must be between the ages of 17 and 80 to register here. Contact the staff directly to make arrangements if you fall outside of that range."
		end
	end


# 	 can do the validation yourself. Convert the string to a date with to_date and check that it's less than 18.years.ago.

# Put that check in a method in your user model, and have it call something like errors.add :dob, 'must be older than 18' if it fails.

# Then at the top of your model call validates :dob_check
	
end
