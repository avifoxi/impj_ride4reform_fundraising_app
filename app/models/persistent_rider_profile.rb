class PersistentRiderProfile < ActiveRecord::Base
	belongs_to :user
	has_many :rider_year_registrations, through: :user

	delegate :full_name, to: :user

	validates_associated :user, on: :create
	validate :has_at_least_one_rider_year_registration

	validates_presence_of :primary_phone, length: {is: 10}
	validates_length_of :secondary_phone, is: 10, :allow_blank => true
	validate :is_within_accepted_age_range 

	## this is stand in method for paperclip -- get routes up first before addin photo saves + stuff
	# attr_accessor :photo_upload

	# http://www.rubydoc.info/gems/paperclip/Paperclip/Storage/S3 

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
		:default_url => "/images/:style/missing.png",
    :storage => :s3,
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	def s3_credentials
    {:bucket => ENV['AWS_S3_BUCKET'], :access_key_id => ENV['AWS_ACCESS_KEY_ID'], :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']}
  end

	private

	def has_at_least_one_rider_year_registration
		unless self.user.rider_year_registrations.count >= 1
      errors.add :rider_year_registrations, "You must be registered for at least one ride to have a persistent profile."
    end
	end

	def is_within_accepted_age_range
		unless self.birthdate < 17.years.ago || self.birthdate > 80.years.ago
			errors.add :birthdate, "You must be between the ages of 17 and 80 to register here. Contact the staff directly to make arrangements if you fall outside of that range."
		end
	end

end
