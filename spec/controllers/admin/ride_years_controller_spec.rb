require 'rails_helper'

RSpec.describe Admin::RideYearsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	let(:old_ride_year){ FactoryGirl.create(:ride_year, :old)}
	let(:new_ry_attr ){ FactoryGirl.attributes_for(:ride_year, :current)}
	# login_admin(FactoryGirl.create(:admin))
	
	context 'authenticates admin before action' do
		it 'redirects non logged in user to admin sign in page' do 
			get :index
			expect(response).to redirect_to(new_admin_session_path)
		end

		it 'allows logged in admin to access actions' do 
			sign_in admin
			get :index
			expect(response).to render_template(:index)
		end
	end

	context 'index' do 
		it 'renders created ride years' do 
			sign_in admin
			get :index
			expect(assigns(:ride_years)).to eq([old_ride_year])
			expect(response).to render_template(:index)
		end
	end

	context 'new' do 
		it 'prepares new template for logged in admin, references current year' do 
			old_ride_year
			sign_in admin
			get :new
			expect(response).to render_template(:new)
			expect(assigns(:current)).to eq(old_ride_year)
		end
	end

	context 'create' do 
		it 'allows logged in admin to create new ride year' do 
			old_ride_year
			sign_in admin
			expect(RideYear.all.count).to eq(1)
			post :create, ride_year: new_ry_attr
			expect(RideYear.all.count).to eq(2)
			expect(response).to redirect_to(admin_ride_years_path)
		end

		it 'redirects to edit when ride year has errors, and does not save to db' do 
			old_ride_year
			sign_in admin
			expect(RideYear.all.count).to eq(1)
			post :create, ride_year: {year: 'invalid params dude'}
			expect(RideYear.all.count).to eq(1)
			expect(response).to render_template(:edit)

		end
	end
	

	# it 'allows logged in admin to get new admin template' do
	# 	# Devise::TestHelper method
	# 	sign_in admin
	# 	get :new
	# 	expect(response).to render_template(:new)
	# end

	# it 'allows admin to create new admin with valid params' do 
	# 	sign_in admin
	# 	post :create, admin: fresh_attrs
	# 	expect(Admin.last.username).to eq(fresh_attrs[:username])
	# 	expect(response).to redirect_to(admin_admins_path)
	# end

	# it 'rejects create new admin with invalid params' do 
	# 	sign_in admin
	# 	post :create, admin: {username: 'incomplete'}
	# 	expect(response).to render_template(:new)
	# 	expect(Admin.last).to eq(admin)
	# end


end
