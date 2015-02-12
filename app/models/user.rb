class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	
  has_many :mailing_addresses

	has_one :persistent_rider_profile

  accepts_nested_attributes_for :mailing_addresses, :persistent_rider_profile

	has_many :rider_year_registrations
	has_many :receipts

  TITLES = ['Mr', 'Mrs', 'Ms', 'Dr', 'Rabbi', 'Cantor', 'Chazzan', 'Educator', 'None']

  validates_presence_of :first_name, :last_name, :email
  validates_inclusion_of :title, :in => TITLES

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

  # def complete_donor_list_for_all_rides
  # 	drns = DonorRiderNote.where(rider: self)
  # end

end
