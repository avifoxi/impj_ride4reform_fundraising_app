require 'rails_helper'

RSpec.describe MailingAddressesController, :type => :controller do
	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }
	let(:second_m_a_params) { FactoryGirl.attributes_for(:mailing_address, :second) }
	# let(:donation) {FactoryGirl.create(:donation, :with_valid_associations_before_fee_processed)}


	before do |example|

		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
		@prp.mailing_addresses.create(m_a_params)
		
	end

	context 'access + permissions' do
		it 'redirects non-logged in users away to log in' do 
			get :new
			expect(response).to redirect_to(new_user_session_path)
		end

		it 'allows logged in users to access ' do 
			sign_in user
			get :new
			expect(response).to render_template(:new)
		end

		it 'allows associated user to edit' do 
			sign_in @prp.user
			get :edit, id: @prp.mailing_addresses.first.id
			expect(response).to render_template(:edit)
			expect( assigns(:m_a) ).to eq(@prp.mailing_addresses.first)
		end
		
		it 'redirects non-associated user trying to edit' do 
			sign_in user
			get :edit, id: @prp.mailing_addresses.first.id
			expect(response).to redirect_to(root_path)
		end
	end

	# context 'new' do
	# 	it 'assigns appropriately and renders form' do
	# 		get :new, persistent_rider_profile_id: @prp.id
	# 		expect( assigns(:donation)).to be_a(Donation)
	# 		expect( assigns(:rider) ).to eq(PersistentRiderProfile.last)
	# 	end
	# end

	# context 'create' do 
	# 	before(:each) do 
	# 		@don_count = Donation.all.count
	# 		@user_count = User.all.count
	# 	end

	# 	it 'create new user, and create new donation' do
	# 		don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
	# 		post :create, {
	# 			persistent_rider_profile_id: @prp.id,
	# 			donation: don_params
	# 		}
	# 		expect(response).to redirect_to(new_donation_payment_path(Donation.last) )
	# 		expect(Donation.all.count).to eq(@don_count + 1)
	# 		expect(User.all.count).to eq(@user_count + 1)
	# 	end

	# 	it 'finds existing user in db, and creates new donation' do 
	# 		user 
	# 		@user_count = User.all.count
	# 		# don_count = Donation.all.count
	# 		don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
	# 		post :create, {
	# 			persistent_rider_profile_id: @prp.id,
	# 			donation: don_params
	# 		}
	# 		expect(response).to redirect_to(new_donation_payment_path(Donation.last) )
	# 		expect(Donation.all.count).to eq(@don_count + 1)
	# 		expect(User.all.count).to eq(@user_count)
	# 	end

	# 	it 'donation errors, valid user, re-renders new' do 
	# 		don_params.except!(:amount)
	# 		don_params[:user] = FactoryGirl.attributes_for(:user, :donor)
	# 		post :create, {
	# 			persistent_rider_profile_id: @prp.id,
	# 			donation: don_params
	# 		}
	# 		expect(response).to render_template(:new_for_rider)
	# 		expect(Donation.all.count).to eq(@don_count)
	# 		expect(User.all.count).to eq(@user_count + 1)
	# 		expect( assigns(:errors)).to_not be_empty

	# 	end

	# 	it 'donation valid, invalid user, re-renders new' do 
	# 		don_params[:user] = FactoryGirl.attributes_for(:user, :donor).except!(:email)
	# 		post :create, {
	# 			persistent_rider_profile_id: @prp.id,
	# 			donation: don_params
	# 		}
	# 		expect(response).to render_template(:new_for_rider)
	# 		expect(Donation.all.count).to eq(@don_count)
	# 		expect(User.all.count).to eq(@user_count)
	# 		expect( assigns(:errors)).to_not be_empty
	# 	end

	# 	it 'all input is junk, re-renders new' do
	# 		don_params.except!(:amount)
	# 		don_params[:user] = FactoryGirl.attributes_for(:user, :donor).except!(:email)
	# 		post :create, {
	# 			persistent_rider_profile_id: @prp.id,
	# 			donation: don_params
	# 		}
	# 		expect(response).to render_template(:new_for_rider)
	# 		expect(Donation.all.count).to eq(@don_count)
	# 		expect(User.all.count).to eq(@user_count)
	# 		expect( assigns(:errors)).to_not be_empty
	# 	end
	# end

	# context 'new_donation_payment', :build_donation_pre_fee do
	# 	it 'assigns appropriately and renders form' do

	# 		get :new_donation_payment, id: @donation.id
	# 		expect( assigns(:donation)).to eq(@donation)
	# 		expect( assigns(:custom_billing_address) ).to be_a(MailingAddress)
	# 		expect( assigns(:mailing_addresses) ).to eq( @donation.mailing_addresses)
	# 	end
	# end

	# context 'create_donation_payment', :build_donation_pre_fee, :don_fee_params do

	# 	before(:each) do 
	# 		@rec_count = Receipt.all.count
	# 		@ma_count = MailingAddress.all.count
	# 		@rider_raised_sum = @donation.rider_year_registration.raised
	# 	end
		
	# 	it 'all valid inputs, creates new address, receipt, and updates donation to fee_is_processed', :vcr, record: :new_episodes do 
			
	# 		post :create_donation_payment, {
	# 			id: @donation.id,
	# 			donation: @don_fee
	# 		}
	# 		rider = @donation.rider.persistent_rider_profile
	# 		expect(response).to redirect_to(persistent_rider_profile_path(rider) )
	# 		expect(Receipt.all.count).to eq(@rec_count + 1)
	# 		expect(MailingAddress.all.count).to eq(@ma_count + 1)
	# 		expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum + @donation.amount)
	# 	end

	# 	it 'all valid inputs, associate to existing address, create receipt, and updates donation to fee_is_processed', :vcr, record: :new_episodes do 
	# 		@don_fee['custom_billing_address'] = '0'

	# 		post :create_donation_payment, {
	# 			id: @donation.id,
	# 			donation: @don_fee
	# 		}
	# 		rider = @donation.rider.persistent_rider_profile
	# 		expect(response).to redirect_to(persistent_rider_profile_path(rider) )
	# 		expect(Receipt.all.count).to eq(@rec_count + 1)
	# 		expect(MailingAddress.all.count).to eq(@ma_count)
	# 		expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum + @donation.amount)
	# 	end

	# 	it 'corrupt credit card info, associate to existing address, re-renders with payment errrors' do 
	# 		@don_fee['custom_billing_address'] = '0'
	# 		@don_fee['cc_number'] = 'corrupt!!'

	# 		post :create_donation_payment, {
	# 			id: @donation.id,
	# 			donation: @don_fee
	# 		}
	# 		expect(response).to render_template(:new_donation_payment)
	# 		expect(Receipt.all.count).to eq(@rec_count)
	# 		expect( assigns(:errors)).to_not be_empty
	# 		expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
	# 	end

	# 	it 'valid credit card, invalid custom address, re-renders with payment errrors' do 
	# 		@don_fee[:mailing_address]['line_1'] = nil

	# 		post :create_donation_payment, {
	# 			id: @donation.id,
	# 			donation: @don_fee
	# 		}
	# 		expect(response).to render_template(:new_donation_payment)
	# 		expect(Receipt.all.count).to eq(@rec_count)
	# 		expect( assigns(:errors)).to_not be_empty
	# 		expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
	# 	end

	# 	it 'valid credit card, user forgets all mailing_address info, re-renders with payment errrors' do 
	# 		@don_fee[:mailing_address] = nil
	# 		@don_fee[:mailing_addresses] = nil
	# 		@don_fee[:custom_billing_address] = '0'

	# 		post :create_donation_payment, {
	# 			id: @donation.id,
	# 			donation: @don_fee
	# 		}
	# 		expect(response).to render_template(:new_donation_payment)
	# 		expect(Receipt.all.count).to eq(@rec_count)
	# 		expect( assigns(:payment_errors)).to_not be_empty
	# 		expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
	# 	end
	# end

end
