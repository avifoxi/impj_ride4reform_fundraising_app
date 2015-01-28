require 'rails_helper'
# require 'spec_helper'


RSpec.describe User, :type => :model do

	it "has a valid factory" do
		user = create(:user)
		expect(user).to be_an_instance_of(User)
	end

	# it "is invalid without a firstname" 
	# it "is invalid without a lastname" 
	# it "returns a contact's full name as a string"

end
