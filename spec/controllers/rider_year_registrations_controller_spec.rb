require 'rails_helper'

RSpec.describe RiderYearRegistrationsController, :type => :controller do

	let(:user) { FactoryGirl.create(:user) }
	let(:ryr_attrs) { FactoryGirl.attributes_for(:rider_year_registration)}

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


		end

	end

end
