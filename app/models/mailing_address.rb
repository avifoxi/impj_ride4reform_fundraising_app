class MailingAddress < ActiveRecord::Base
  belongs_to :user
  has_many :rider_year_registrations, through: :user

  validates_presence_of :user
  validates_associated :user, on: :create
  validates_presence_of :line_1, :city, :state, :zip
  validates :zip, length: { is: 5 }
  validate :zip_num_length_check, if: :zip

  validate :check_zip_against_city_and_state, if: [:zip, :state]

  before_save :first_in_is_primary

  def one_liner
    o_l = self.line_1 + ' ' 
    if self.line_2 
      o_l += (self.line_2 + ' ')
    end
    o_l + self.city + ' ' + self.zip
  end

  
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

  # using area gem. neat!

  def check_zip_against_city_and_state
    # confirmed_city = self.zip.to_region(:city => true)
    confirmed_state = self.zip.to_region(:state => true)
    unless self.state == confirmed_state
      errors.add :zip, "zip code and state must correspond"
      errors.add :state, "zip code and state must correspond"
    end
  end

end










