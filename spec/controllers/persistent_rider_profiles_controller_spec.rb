require 'rails_helper'

RSpec.describe PersistentRiderProfilesController, :type => :controller do

	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }

	before do |example|

		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
		
		if example.metadata[:build_donation_pre_fee]
      # must build prp manually... bc of validations, etc
      user.mailing_addresses.create(m_a_params)
	    @donation = Donation.new(don_params)
	    @donation.update_attributes(rider_year_registration: ryr, user: user)
    end
    # if example.metadata[:don_fee_params]
    # 	@don_fee = {
    # 		cc_type: 'visa',
    # 		cc_number: '4417119669820331',
    # 		cc_expire_month: '11', 
    # 		'cc_expire_year(1i)' => "2015", 
    # 		cc_cvv2: '874', 
    # 		custom_billing_address: "1",
    # 		mailing_address: FactoryGirl.attributes_for(:mailing_address, :second), 
    # 		mailing_addresses: "#{user.mailing_addresses.first.id}"
    # 	}
    # end		
	end

	context 'access + permissions' do
		it 'anyone can access index' do 
			get :index
			expect(response).to render_template(:index)
			sign_in user
			get :index
			expect(response).to render_template(:index)
		end

		it 'anyone can access show' do 
			get :show, id: @prp.id
			expect(response).to render_template(:show)
			sign_in user
			get :show, id: @prp.id
			expect(response).to render_template(:show)
		end



		# it 'allows logged in users to access ' do 
		# 	sign_in user
		# 	get :new, persistent_rider_profile_id: @prp.id
		# 	expect(response).to render_template(:new)
		# end
	end


end
