require 'rails_helper'

RSpec.describe CustomRideOption, :type => :model do
	let( :option ){ create( :custom_ride_option ) }

  it 'has a valid factory' do 
  	expect( build(:custom_ride_option) ).to be_a( CustomRideOption )
  end

  describe 'registered riders' do
  	it 'returns no riders if none are registered' do
  		expect( option.registered_riders ).to be_empty
  	end

  	it 'returns only riders who have chosen this ride option' do
  		ride_year = option.ride_year
  		rider1 = build(:rider_year_registration, :with_valid_associations).update_attributes(ride_year: ride_year)

  		rider2 = build(:rider_year_registration, :old)

  		rider2.update_attributes(ride_year: option.ride_year, ride_option: option.display_name )
  		expect( option.registered_riders ).to eq([ rider2 ])
  	end
  end
end
