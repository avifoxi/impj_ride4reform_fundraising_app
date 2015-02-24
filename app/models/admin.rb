class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable


  validates_presence_of :username, :email, :password
  validates_uniqueness_of :username, :email
  validates_confirmation_of :email, :password
end
