require 'rails_helper'

RSpec.describe MailingAddressesController, :type => :controller do
	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }
	let(:second_m_a_params) { FactoryGirl.attributes_for(:mailing_address, :second) }

	before do |example|
		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
		@prp.mailing_addresses.create(m_a_params)
		@ma_count = MailingAddress.all.count

		if example.metadata[:sign_in_prp]
    	sign_in @prp.user
    end

	end

	context 'access + permissions' do
		it 'redirects non-logged in users away to log in' do 
			get :new
			expect(response).to redirect_to(new_user_session_path)
		end

		it 'allows logged in users to access ' do 
			sign_in user
			get :new
			expect(response).to render_template(:new)
		end

		it 'allows associated user to edit', :sign_in_prp do 
			get :edit, id: @prp.mailing_addresses.first.id
			expect(response).to render_template(:edit)
			expect( assigns(:m_a) ).to eq(@prp.mailing_addresses.first)
		end
		
		it 'redirects non-associated user away from edit' do 
			sign_in user
			get :edit, id: @prp.mailing_addresses.first.id
			expect(response).to redirect_to(root_path)
		end

		it 'redirects non-associated user away from update' do 
			sign_in user
			ma_count = MailingAddress.all.count
			post :edit, {
				id: @prp.mailing_addresses.first.id,
				mailing_address: {
					line_1: 'i cannot change this bc i am not the owner of this addy'
				}
			}
			expect(response).to redirect_to(root_path)
			expect(@prp.mailing_addresses.first.line_1).to_not eq('i cannot change this bc i am not the owner of this addy')
		end
	end

	context 'new' do
		it 'assigns appropriately and renders form', :sign_in_prp do
			get :new, persistent_rider_profile_id: @prp.id
			expect( assigns(:m_a)).to be_a(MailingAddress)
		end
	end

	context 'create' do 

		it 'registered rider, with valid params', :sign_in_prp do
			post :create, {
				mailing_address: second_m_a_params
			}
			expect(response).to redirect_to(edit_persistent_rider_profile_path(@prp) )
			expect(MailingAddress.all.count).to eq(@ma_count + 1)
			expect(@prp.mailing_addresses.count).to eq(2)
		end

		it 'registered rider, with invalid params', :sign_in_prp  do 
			post :create, {
				mailing_address: second_m_a_params.except(:line_1)
			}
			expect(response).to render_template(:new)
			expect(assigns(:errors)).to_not be_empty
			expect(MailingAddress.all.count).to eq(@ma_count)
		end
	end

	context 'edit' do
		it 'assigns appropriately and renders form', :sign_in_prp do
			get :edit, id: @prp.mailing_addresses.first.id
			expect( assigns(:m_a)).to eq(@prp.mailing_addresses.first)
		end
	end


	context 'update' do 

		it 'registered rider, edits with valid params', :sign_in_prp do
			put :update, {
				id: @prp.mailing_addresses.first.id,
				mailing_address: second_m_a_params
			}
			expect(response).to redirect_to(edit_persistent_rider_profile_path(@prp) )
			expect(MailingAddress.all.count).to eq(@ma_count)
			expect(@prp.mailing_addresses.first.line_1).to eq('second line second')
		end

		it 'registered rider, with invalid params', :sign_in_prp  do 
			put :update, {
				id: @prp.mailing_addresses.first.id,
				mailing_address: second_m_a_params.except(:zip)
			}
			expect(response).to render_template(:edit)
			expect(MailingAddress.all.count).to eq(@ma_count)
			expect(assigns(:m_a)).to eq(@prp.mailing_addresses.first)
			expect(assigns(:errors)).to_not be_empty
		end
	end

	context 'destroy' do 

		it 'registered rider, tries to delete their sole address', :sign_in_prp do
			delete :destroy, {
				id: @prp.mailing_addresses.first.id
			}
			expect(response).to redirect_to(edit_persistent_rider_profile_path(@prp) )
			expect(MailingAddress.all.count).to eq(@ma_count)
			expect(flash[:alert]).to be_present	
		end

		it 'registered rider, deletes their addy with a second on file', :sign_in_prp  do 
			if @prp.mailing_addresses.create(second_m_a_params)
				@ma_count = MailingAddress.all.count
			end
			delete :destroy, {
				id: @prp.mailing_addresses.first.id
			}
			expect(MailingAddress.all.count).to eq(@ma_count - 1)
		end
	end

end
