require 'rails_helper'

RSpec.describe RiderYearRegistrationsController, :type => :controller do

	let(:user) { FactoryGirl.create(:user) }
	let(:ryr_attrs) { FactoryGirl.attributes_for(:rider_year_registration)}
	let(:ryr_instance) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }

	before(:each) { sign_in user } 
	before(:each) { FactoryGirl.create(:ride_year, :current) }

	context 'authenticates user signed in before action' do

		it 'redirects non logged in user to sign in page' do 
			sign_out user
			get :new
			expect(response).to redirect_to(new_user_session_path)
		end

		it 'allows logged in user to access actions' do 

			get :new
			expect(response).to render_template(:new)
		end
	end

	context 'new user starts registration' do 
		it 'renders new form for logged in user' do 

			get :new
			expect(assigns(:ryr)).to be_a(RiderYearRegistration)
		end
	end

	context 'create' do 

		it 'valid user, valid ryr, adds a rider_year_registration, and shuttles along to agree_to_terms' do 

			ryr_count = RiderYearRegistration.all.count
			post :create, rider_year_registration: ryr_attrs

			expect(RiderYearRegistration.all.count).to eq(ryr_count + 1)
			expect(response).to redirect_to(rider_year_registrations_agree_to_terms_path(rider_year_registration: RiderYearRegistration.last))
		end

		it 'invalid ryr, re-renders :new w errors, does not create' do 
			ryr_count = RiderYearRegistration.all.count
			ryr_attrs['ride_option'] = 'cheese melting'
			post :create, rider_year_registration: ryr_attrs

			expect(RiderYearRegistration.all.count).to eq(ryr_count)
			expect(response).to render_template(:new)
			expect(assigns(:errors)).not_to be_empty
		end

	end
 
	context 'new_agree_to_terms' do 
		it 'valid user, valid ryr, serves new agree_to_terms and assigns instance var' do 

			get :new_agree_to_terms, rider_year_registration: ryr_instance

			expect(response).to render_template(:new_agree_to_terms)
			expect(assigns(:ryr)).to eq(ryr_instance)
		end
	end

	context 'create_agree_to_terms' do 
		it 'valid user, valid ryr, updates agree_to_terms moves along ot prp' do 

			post :create_agree_to_terms, ryr_id: ryr_instance.id, rider_year_registration: { agree_to_terms: 1 }


			expect(response).to redirect_to(rider_year_registrations_persistent_rider_profile_path(rider_year_registration: ryr_instance))
			expect(ryr_instance.agree_to_terms).to eq(true)
		end

		it 'valid user, valid ryr, does not agree to terms, error and re-render' do 

			post :create_agree_to_terms, ryr_id: ryr_instance.id, rider_year_registration: { agree_to_terms: 'you can take your terms n shove em' }


			expect(response).to render_template(:new_agree_to_terms)
			expect(assigns(:errors)).not_to be_empty
		end
	end

	context 'new_persistent_rider_profile' do 
		it 'valid user, valid ryr, serves new p_r_p and assigns instance var' do 

			get :new_persistent_rider_profile, rider_year_registration: ryr_instance


			expect(response).to render_template(:new_persistent_rider_profile)
			expect(assigns(:ryr)).to eq(ryr_instance)

		end

	end

	context 'create_persistent_rider_profile' do 
		it 'valid user, valid ryr, serves new p_r_p and assigns instance var' do 

			post :create_persistent_rider_profile, ryr_id: ryr_instance.id, rider_year_registration: { persistent_rider_profile_attributes: prp_params }


			expect(response).to redirect_to(rider_year_registrations_mailing_address_path(rider_year_registration: ryr_instance))
			# expect(assigns(:ryr)).to eq(ryr_instance)
			
		end

	end

end
