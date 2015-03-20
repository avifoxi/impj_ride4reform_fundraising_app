require 'rails_helper'

RSpec.describe DonationsController, :type => :controller do

	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }
	let (:don_params) {FactoryGirl.attributes_for(:donation)}


	before do |example|

		# must build prp manually... bc of validations, etc
    @prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
  	@prp.update_attributes(prp_params)

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
		it 'create new user, and create new donation' do
			don_params[:user] = FactoryGirl.attributes_for(:user, :donor)

			post :create, {
				persistent_rider_profile_id: @prp.id,
				donation: don_params
			}

			
			expect(response).to redirect_to(new_donation_payment_path(Donation.last) )
		end

	end

end
