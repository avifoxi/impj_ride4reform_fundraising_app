require 'rails_helper'

RSpec.describe Admin::RideYearsController, :type => :controller do

	let(:admin) { FactoryGirl.create(:admin) }
	let(:old_ride_year){ FactoryGirl.create(:ride_year, :old)}
	let(:new_ry_attr ){ FactoryGirl.attributes_for(:ride_year, :current)}
	# login_admin(FactoryGirl.create(:admin))
	
	context 'index' do
		it 'redirects non logged in user to admin sign in page' do 
			get :index
			expect(response).to redirect_to(new_admin_session_path)
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
