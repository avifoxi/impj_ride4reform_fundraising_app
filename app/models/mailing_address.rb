class MailingAddress < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user
  validates_associated :user, on: :create
  validates_presence_of :line_1, :city, :state, :zip
  validates :zip, length: { is: 5 }, numericality: { only_integer: true }

  before_save :first_in_is_primary
  
  private

  def first_in_is_primary
  	user = self.user
  	if user.mailing_addresses.length < 1
  		self.users_primary = 1
  	end
  end

end
