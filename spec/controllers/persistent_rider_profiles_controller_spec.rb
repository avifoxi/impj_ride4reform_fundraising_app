require 'rails_helper'

RSpec.describe PersistentRiderProfilesController, :type => :controller do

	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:ryr_old) { FactoryGirl.create(:rider_year_registration, :old) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }

	before do |example|

		if example.metadata[:multi_year_prps]
      @p_old = ryr_old.user.build_persistent_rider_profile(user: ryr_old.user)
	  	@p_old.update_attributes(prp_params)
    end

		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
	  
	  if example.metadata[:sign_in_prp_owner]
      sign_in @prp.user
    end
		
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

	context 'non-logged in access + permissions' do
		it 'anyone can access index' do 
			get :index
			expect(response).to render_template(:index)
			# next method actually not comprehenseiv -- as not filtering on ride_year -- but do this in index test
			expect( assigns(:riders)).to eq(PersistentRiderProfile.all)
		end

		it 'anonymous users can access show, without seeing edit link' do 
			get :show, id: @prp.id
			expect(response).to render_template(:show)
			expect(response.body).not_to eq( 'Edit your profile?')
		end

		it 'redirects non-prp-owner-user away from edit page' do 
			sign_in user
			get :edit, id: @prp.id
			expect(response).to redirect_to root_path
			expect(response.body).not_to eq( 'Edit')
		end
	end

	context 'show' do
		it 'anon user, assigns locals appropriately' do
			get :show, id: @prp.id
			expect( assigns(:prp_owner_signed_in) ).to eq(false)
			expect( assigns(:rider) ).to eq(@prp)
			expect( assigns(:years_registration)).to eq(@prp.rider_year_registrations.last)
			expect( assigns(:donations)).to eq(@prp.rider_year_registrations.last.donations)
			expect( assigns(:raised)).to eq(@prp.rider_year_registrations.last.raised)
			expect( assigns(:percent_of_goal)).to eq(@prp.rider_year_registrations.last.percent_of_goal)
			expect( assigns(:goal)).to eq(@prp.rider_year_registrations.last.goal)
		end

		it 'prp-owner signs in, assigns locals appropriately, shows edit link', :sign_in_prp_owner do
			get :show, id: @prp.id	
			expect( assigns(:prp_owner_signed_in) ).to eq(true)
			expect( assigns(:rider) ).to eq(@prp)
			
		end
	end

	context 'index' do
		it 'renders all prps for current ride year', :multi_year_prps do

			p "p_old::: #{@p_old.inspect}" 
			p "p NEW::: #{@prp.inspect}" 
			get :index
			# expect( assigns(:prp_owner_signed_in) ).to eq(false)
			# expect( assigns(:rider) ).to eq(@prp)
			# expect( assigns(:years_registration)).to eq(@prp.rider_year_registrations.last)
			# expect( assigns(:donations)).to eq(@prp.rider_year_registrations.last.donations)
			# expect( assigns(:raised)).to eq(@prp.rider_year_registrations.last.raised)
			# expect( assigns(:percent_of_goal)).to eq(@prp.rider_year_registrations.last.percent_of_goal)
			# expect( assigns(:goal)).to eq(@prp.rider_year_registrations.last.goal)
		end

		# it 'prp-owner signs in, assigns locals appropriately, shows edit link', :sign_in_prp_owner do
		# 	get :show, id: @prp.id	
		# 	expect( assigns(:prp_owner_signed_in) ).to eq(true)
		# 	expect( assigns(:rider) ).to eq(@prp)
			
		# end
	end



end
