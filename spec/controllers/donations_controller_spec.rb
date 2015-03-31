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
      user.mailing_addresses.create(m_a_params)
	    @donation = Donation.new(don_params)
	    @donation.update_attributes(rider_year_registration: ryr, user: user)
    end
    if example.metadata[:don_fee_params]
    	@don_fee = {
    		cc_type: 'visa',
    		cc_number: '4417119669820331',
    		cc_expire_month: '11', 
    		'cc_expire_year(1i)' => "2015", 
    		cc_cvv2: '874', 
    		custom_billing_address: "1",
    		mailing_address: FactoryGirl.attributes_for(:mailing_address, :second), 
    		mailing_addresses: "#{user.mailing_addresses.first.id}"
    	}
    end		
	end

	context 'access + permissions' do
		it 'allows non-logged in users to access ' do 
			get :new, persistent_rider_profile_id: @prp.id
			expect(response).to render_template(:new_for_rider)
		end

		it 'allows logged in users to access ' do 
			sign_in user
			get :new, persistent_rider_profile_id: @prp.id
			expect(response).to render_template(:new_for_rider)
		end
	end

	context 'new' do
		it 'when request is namespaced to rider, assigns appropriately and renders form' do
			get :new, persistent_rider_profile_id: @prp.id
			expect( assigns(:donation)).to be_a(Donation)

			expect( assigns(:rider) ).to eq(PersistentRiderProfile.last)
			expect(response).to render_template(:new_for_rider)
		end

		it 'when not namespaced to rider, assigns to organization and renders form' do
			get :new
			expect( assigns(:donation)).to be_a(Donation)
			expect(response).to render_template(:new_for_organization)
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
			expect(response).to render_template(:new_for_rider)
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
			expect(response).to render_template(:new_for_rider)
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
			expect(response).to render_template(:new_for_rider)
			expect(Donation.all.count).to eq(@don_count)
			expect(User.all.count).to eq(@user_count)
			expect( assigns(:errors)).to_not be_empty
		end
	end

	context 'new_donation_payment', :build_donation_pre_fee do
		it 'assigns appropriately and renders form' do

			get :new_donation_payment, id: @donation.id
			expect( assigns(:donation)).to eq(@donation)
			expect( assigns(:custom_billing_address) ).to be_a(MailingAddress)
			expect( assigns(:mailing_addresses) ).to eq( @donation.mailing_addresses)
		end
	end

	context 'create_donation_payment', :build_donation_pre_fee, :don_fee_params do

		before(:each) do 
			@rec_count = Receipt.all.count
			@ma_count = MailingAddress.all.count
			@rider_raised_sum = @donation.rider_year_registration.raised
			@mailers_count = ActionMailer::Base.deliveries.count
		end
		
		it 'all valid inputs, creates new address, receipt, and updates donation to fee_is_processed', :vcr, record: :new_episodes do 
			
			post :create_donation_payment, {
				id: @donation.id,
				donation: @don_fee
			}
			rider = @donation.rider.persistent_rider_profile
			expect(response).to redirect_to(persistent_rider_profile_path(rider) )
			expect(Receipt.all.count).to eq(@rec_count + 1)
			expect(MailingAddress.all.count).to eq(@ma_count + 1)
			expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum + @donation.amount)
			expect(ActionMailer::Base.deliveries.count).to eq(@mailers_count + 2)
		end

		it 'all valid inputs, associate to existing address, create receipt, and updates donation to fee_is_processed', :vcr, record: :new_episodes do 
			@don_fee['custom_billing_address'] = '0'

			post :create_donation_payment, {
				id: @donation.id,
				donation: @don_fee
			}
			rider = @donation.rider.persistent_rider_profile
			expect(response).to redirect_to(persistent_rider_profile_path(rider) )
			expect(Receipt.all.count).to eq(@rec_count + 1)
			expect(MailingAddress.all.count).to eq(@ma_count)
			expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum + @donation.amount)
			expect(ActionMailer::Base.deliveries.count).to eq(@mailers_count + 2)
		end

		it 'corrupt credit card info, associate to existing address, re-renders with payment errrors' do 
			@don_fee['custom_billing_address'] = '0'
			@don_fee['cc_number'] = 'corrupt!!'

			post :create_donation_payment, {
				id: @donation.id,
				donation: @don_fee
			}
			expect(response).to render_template(:new_donation_payment)
			expect(Receipt.all.count).to eq(@rec_count)
			expect( assigns(:errors)).to_not be_empty
			expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
			expect(ActionMailer::Base.deliveries.count).to eq(@mailers_count)

		end

		it 'valid credit card, invalid custom address, re-renders with payment errrors' do 
			@don_fee[:mailing_address]['line_1'] = nil

			post :create_donation_payment, {
				id: @donation.id,
				donation: @don_fee
			}
			expect(response).to render_template(:new_donation_payment)
			expect(Receipt.all.count).to eq(@rec_count)
			expect( assigns(:errors)).to_not be_empty
			expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
			expect(ActionMailer::Base.deliveries.count).to eq(@mailers_count)

		end

		it 'valid credit card, user forgets all mailing_address info, re-renders with payment errrors' do 
			@don_fee[:mailing_address] = nil
			@don_fee[:mailing_addresses] = nil
			@don_fee[:custom_billing_address] = '0'

			post :create_donation_payment, {
				id: @donation.id,
				donation: @don_fee
			}
			expect(response).to render_template(:new_donation_payment)
			expect(Receipt.all.count).to eq(@rec_count)
			expect( assigns(:payment_errors)).to_not be_empty
			expect(@donation.rider_year_registration.raised).to eq(@rider_raised_sum)
			expect(ActionMailer::Base.deliveries.count).to eq(@mailers_count)
		end
	end

end
