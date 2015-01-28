class PersistentRiderProfile < ActiveRecord::Base
	belongs_to :user

	validates_associated :user, on: :create

	
end
