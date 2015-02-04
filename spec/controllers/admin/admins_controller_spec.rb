require 'rails_helper'

RSpec.describe Admin::AdminsController, :type => :controller do
	let(:admin) { FactoryGirl.create(:admin) }	
	# login_admin(FactoryGirl.create(:admin))
	
	it 'redirects non logged in user to admin sign in page' do 
		get :index
		expect(response).to redirect_to(new_admin_session_path)
	end

	it 'allows logged in admin to get new admin template' do
		# login_admin(admin)
		sign_in admin
		get :new
		expect(response).to render_template(:new)
	end

end
