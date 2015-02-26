require 'rails_helper'

RSpec.describe RiderYearRegistrationsController, :type => :controller do

	let(:user) { FactoryGirl.create(:user) }
	let(:ryr_attrs) { FactoryGirl.attributes_for(:rider_year_registration, :with_valid_associations)}
	let(:ryr_instance) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }


	before do |example|
    unless example.metadata[:skip_sign_in]
      sign_in ryr_instance.user
    end

    if example.metadata[:ryr_fully_associated_for_pay]
    	ryr_instance.mailing_addresses.create(m_a_params)
    	prp = ryr_instance.user.build_persistent_rider_profile(user: ryr_instance.user)
    	prp.update_attributes(prp_params)
    end

    FactoryGirl.create(:ride_year, :current)
	end


	context 'before_action redirection', :skip_sign_in do
		it 'redirects non logged in user to sign in page' do 
			# sign_out ryr_instance.user 
			get :new
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	context 'before_action validates current_user' do
		it 'allows logged in user to access actions' do 
			get :new
			expect(response).to render_template(:new)
		end
	end

	context 'new user starts registration, no extant ryrs', :skip_sign_in do 
		it 'renders new form for logged in user' do 
			sign_in user
			get :new
			expect(assigns(:ryr)).to be_a(RiderYearRegistration)
		end
	end

	context 'create' do 

		it 'valid user, valid ryr, adds a rider_year_registration, and shuttles along to agree_to_terms', :skip_sign_in do 

			sign_in user
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
		it 'valid user, valid ryr, valid params, creates associated p_r_p ' do 
			prp_count = PersistentRiderProfile.all.count

			post :create_persistent_rider_profile, ryr_id: ryr_instance.id, rider_year_registration: { persistent_rider_profile_attributes: prp_params }

			
			expect(response).to redirect_to(rider_year_registrations_mailing_address_path(rider_year_registration: ryr_instance))

			expect(PersistentRiderProfile.last.user).to eq(ryr_instance.user)
			expect(PersistentRiderProfile.all.count).to eq(prp_count + 1)

		end

		it 'valid user, valid ryr, invalide params, rerenders with errors' do 
			prp_count = PersistentRiderProfile.all.count
			prp_params['primary_phone'] = nil
			post :create_persistent_rider_profile, ryr_id: ryr_instance.id, rider_year_registration: { persistent_rider_profile_attributes: prp_params }

			
			expect(response).to render_template(:new_persistent_rider_profile)
			expect(PersistentRiderProfile.all.count).to eq(prp_count)
			expect(assigns(:errors)).not_to be_empty
		end
	end

	context 'new_mailing_address' do 
		it 'valid user, valid ryr, serves new mailing addy and assigns instance var' do 

			get :new_mailing_address, rider_year_registration: ryr_instance


			expect(response).to render_template(:new_mailing_address)
			expect(assigns(:ryr)).to eq(ryr_instance)

		end

	end

	context 'create_mailing_address' do 
		it 'valid user, valid ryr, valid params, creates associated address ' do 
			m_a_count = MailingAddress.all.count

			# p "m_a params"
			# p "#{m_a_params.inspect}"

			post :create_mailing_address, ryr_id: ryr_instance.id, rider_year_registration: { mailing_addresses_attributes: { '0' => m_a_params } }

			
			expect(response).to redirect_to(rider_year_registrations_pay_reg_fee_path(rider_year_registration: ryr_instance))

			expect(MailingAddress.last.user).to eq(ryr_instance.user)
			expect(MailingAddress.all.count).to eq(m_a_count + 1)

		end

		it 'valid user, valid ryr, invalid params, rerenders with errors' do 
			m_a_count = MailingAddress.all.count
			m_a_params['line_1'] = nil
			post :create_mailing_address, ryr_id: ryr_instance.id, rider_year_registration: { mailing_addresses_attributes: { '0' => m_a_params } }

			
			expect(response).to render_template(:new_mailing_address)
			expect(MailingAddress.all.count).to eq(m_a_count)
			expect(assigns(:errors)).not_to be_empty
		end
	end


	context 'new_pay_reg_fee', :ryr_fully_associated_for_pay do 
		
		it 'valid user, valid ryr, valid associations for payment, serves new payment form and assigns vars' do 

			get :new_pay_reg_fee, rider_year_registration: ryr_instance

			expect(response).to render_template(:new_pay_reg_fee)
			expect(assigns(:ryr)).to eq(ryr_instance)
			expect(assigns(:mailing_addresses)).to eq(ryr_instance.mailing_addresses)
			expect(assigns(:custom_billing_address)).to be_a(MailingAddress)
			expect(assigns(:registration_fee)).to eq(RideYear.current.registration_fee)
		end
	end

	context 'create_pay_reg_fee', :ryr_fully_associated_for_pay do 
		
		it 'valid user, valid ryr, valid params, creates associated address ' do 
			m_a_count = MailingAddress.all.count

			# p "m_a params"
			# p "#{m_a_params.inspect}"

			post :create_mailing_address, ryr_id: ryr_instance.id, rider_year_registration: { mailing_addresses_attributes: { '0' => m_a_params } }

			
			expect(response).to redirect_to(rider_year_registrations_pay_reg_fee_path(rider_year_registration: ryr_instance))

			expect(MailingAddress.last.user).to eq(ryr_instance.user)
			expect(MailingAddress.all.count).to eq(m_a_count + 1)

		end
	end


end
