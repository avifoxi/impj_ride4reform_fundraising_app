require 'rails_helper'

RSpec.describe RiderYearRegistrationsController, :type => :controller do

	let(:user) { FactoryGirl.create(:user) }
	

	context 'authenticates user signed in before action' do

		it 'redirects non logged in user to sign in page' do 
			get :new
			expect(response).to redirect_to(new_user_session_path)
		end

		it 'allows logged in user to access actions' do 
			sign_in user
			p '#'*80
			p 'freshie'
			p "#{user.inspect}"
			get :new

			expect(response).to render_template(:new)
		end
	end

	context 'new user starts registration' do 
		it 'renders new form for logged in user' do 

			sign_in user
			get :new
			expect(assigns(:ryr)).to be_a(RiderYearRegistration)
		end
	end

	context 'create' do 

		# it ''

	end

end
