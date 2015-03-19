class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	
  # not saved to DB, but simple_form validates inputs against model -- so we add these attrs that are not persisted
  # very railsy -- perhaps an odd design choice
  attr_accessor :custom_billing_address, :cc_type, :cc_number, :cc_expire_month, :cc_expire_year, :cc_cvv2

  has_many :mailing_addresses

	has_one :persistent_rider_profile

  accepts_nested_attributes_for :mailing_addresses, :persistent_rider_profile

	has_many :rider_year_registrations
	has_many :receipts
  has_many :donations

  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr', 'Rabbi', 'Cantor', 'Chazzan', 'Educator', 'None']

  validates_presence_of :first_name, :last_name, :email
  validates_inclusion_of :title, :in => TITLES

  # credit card info validation -- not saving to DB, but validating on form submission before shuttling to paypal
  validates_inclusion_of :cc_type, :in => [['Visa', 'visa'], ['Mastercard', 'mastercard'], ['Discover', 'discover'], ['AMEX', 'amex']].flatten, :message => 'Please select a card type that we accept', allow_nil: true

  validates :cc_number, length: {is: 16}, allow_nil: true
  validates_inclusion_of :cc_expire_month, :in => (1..12).to_a.map{|num| num.to_s}, allow_nil: true
  validates :cc_cvv2, length: {minimum: 3, maximum: 4}, allow_nil: true


	def set_new_primary_address(mailing_address)
    max = self.mailing_addresses.map{|m| m.users_primary}.max
    mailing_address.update_attributes(users_primary: max + 1)
  end

  def primary_address
  	self.mailing_addresses.max_by{|m| m.users_primary}
  end

  def full_name
    if self.title == "None"
      self.first_name + ' ' + self.last_name
    else
      self.title + ' ' + self.first_name + ' ' + self.last_name
    end
  end

  def rider_in_current_year?
    if self.rider_year_registrations.empty?
      return false
    else
      self.rider_year_registrations.last.ride_year == RideYear.current
    end
  end

  # def complete_donor_list_for_all_rides
  # 	drns = DonorRiderNote.where(rider: self)
  # end

end
