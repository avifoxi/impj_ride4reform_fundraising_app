require 'rails_helper'

RSpec.describe Admin::AdminsController, :type => :controller do
	# login_admin

	it 'redirects non logged in user to admin sign in page' do 
		get :index
		expect(response).to redirect_to(new_admin_session_path)
	end

	

end
