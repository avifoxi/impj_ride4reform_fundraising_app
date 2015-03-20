require 'rails_helper'

RSpec.describe DonationsController, :type => :controller do

	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }
	let (:don_params) {FactoryGirl.attributes_for(:donation)}
	# let(:donation) {FactoryGirl.create(:donation, :with_valid_associations_before_fee_processed)}


	before do |example|

		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
		
		if example.metadata[:build_donation_pre_fee]
      # must build prp manually... bc of validations, etc
	    @donation = Donation.new(don_params)
	    @donation.update_attributes(rider_year_registration: ryr, user: user)
    end		
	end

	context 'access + permissions' do
		it 'allows non-logged in users to access ' do 
			get :new, persistent_rider_profile_id: @prp.id
			expect(response).to render_template(:new)
		end

		it 'allows logged in users to access ' do 
			sign_in user
			get :new, persistent_rider_profile_id: @prp.id
			expect(response).to render_template(:new)
		end
	end

	context 'new' do
		it 'assigns appropriately and renders form' do
			get :new, persistent_rider_profile_id: @prp.id
			expect( assigns(:donation)).to be_a(Donation)
			expect( assigns(:rider) ).to eq(PersistentRiderProfile.last)
		end
	end

	context 'create' do 
		before(:each) do 
			@don_count = Donation.all.count
			@user_count = User.all.count
		end

		it 'create new user, and create new donation' do
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}
			expect(response).to redirect_to(new_donation_payment_path(Donation.last) )
			expect(Donation.all.count).to eq(@don_count + 1)
			expect(User.all.count).to eq(@user_count + 1)
		end

		it 'finds existing user in db, and creates new donation' do 
			user 
			@user_count = User.all.count
			# don_count = Donation.all.count
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}
			expect(response).to redirect_to(new_donation_payment_path(Donation.last) )
			expect(Donation.all.count).to eq(@don_count + 1)
			expect(User.all.count).to eq(@user_count)
		end

		it 'donation errors, valid user, re-renders new' do 
			don_params.except!(:amount)
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}
			expect(response).to render_template(:new)
			expect(Donation.all.count).to eq(@don_count)
			expect(User.all.count).to eq(@user_count + 1)
			expect( assigns(:errors)).to_not be_empty

		end

		it 'donation valid, invalid user, re-renders new' do 
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor).except!(:email)
			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}
			expect(response).to render_template(:new)
			expect(Donation.all.count).to eq(@don_count)
			expect(User.all.count).to eq(@user_count)
			expect( assigns(:errors)).to_not be_empty
		end

		it 'all input is junk, re-renders new' do
			don_params.except!(:amount)
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor).except!(:email)
			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}
			expect(response).to render_template(:new)
			expect(Donation.all.count).to eq(@don_count)
			expect(User.all.count).to eq(@user_count)
			expect( assigns(:errors)).to_not be_empty
		end
	end

	context 'new_donation_payment', :build_donation_pre_fee do
		it 'assigns appropriately and renders form' do
			
			get :new_donation_payment, id: @donation.id
			expect( assigns(:donation)).to eq(@donation)
			# expect( assigns(:rider) ).to eq(PersistentRiderProfile.last)
		end
	end

end
