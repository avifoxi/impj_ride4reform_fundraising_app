require 'rails_helper'

RSpec.describe PersistentRiderProfile, :type => :model do

	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }	
	let(:prp) { FactoryGirl.build(:persistent_rider_profile)}


	it "has a valid factory" do
		expect(prp).to be_an_instance_of(PersistentRiderProfile)
	end

	it "validates user has registered for a ride before creating persistent profile" do 

		not_a_rider = create(:user, :donor)
		prp.user = not_a_rider
		expect(prp.save).to eq(false)
		
		prp.user = ryr.user
		expect(prp.save).to eq(true)

	end


end
