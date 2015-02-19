class MailingAddress < ActiveRecord::Base
  belongs_to :user
  has_many :rider_year_registrations, through: :user

  validates_presence_of :user
  validates_associated :user, on: :create
  validates_presence_of :line_1, :city, :state, :zip
  validates :zip, length: { is: 5 }
  validate :zip_num_length_check

  before_save :first_in_is_primary
  
  private

  def first_in_is_primary
  	user = self.user
  	if user.mailing_addresses.length < 1
  		self.users_primary = 1
  	end
  end

  def zip_num_length_check
    unless self.zip.to_i.to_s.length == self.zip.length
      errors.add :zip, "zip code must be 5 digits long"
    end
  end

end