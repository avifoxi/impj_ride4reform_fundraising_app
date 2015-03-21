require 'rails_helper'

RSpec.describe PersistentRiderProfilesController, :type => :controller do

	let(:user) {FactoryGirl.create(:user, :donor) }
	let(:ryr) { FactoryGirl.create(:rider_year_registration, :with_valid_associations) }
	let(:ryr_old) { FactoryGirl.create(:rider_year_registration, :old) }
	let(:prp_params) { FactoryGirl.attributes_for(:persistent_rider_profile) }
	let(:m_a_params) { FactoryGirl.attributes_for(:mailing_address) }

	before do |example|

		ryr.ride_year.set_as_current

		if example.metadata[:multi_year_prps]
			ryr_old.update_attributes(ride_year: FactoryGirl.create(:ride_year, :old) )
      @p_old = ryr_old.user.build_persistent_rider_profile(user: ryr_old.user)
	  	@p_old.update_attributes(prp_params)
    end

		@prp = ryr.user.build_persistent_rider_profile(user: ryr.user)
	  @prp.update_attributes(prp_params)
	  
	  if example.metadata[:sign_in_prp_owner]
      sign_in @prp.user
    end

	end

	context 'non-logged in access + permissions' do
		it 'anyone can access index' do 
			get :index
			expect(response).to render_template(:index)
			# next method actually not comprehenseiv -- as not filtering on ride_year -- but do this in index test
			expect( assigns(:riders)).to eq(PersistentRiderProfile.all)
		end

		it 'anonymous users can access show, without seeing edit link' do 
			get :show, id: @prp.id
			expect(response).to render_template(:show)
			expect(response.body).not_to eq( 'Edit your profile?')
		end

		it 'redirects non-prp-owner-user away from edit page' do 
			sign_in user
			get :edit, id: @prp.id
			expect(response).to redirect_to root_path
			expect(response.body).not_to eq( 'Edit')
		end
	end

	context 'show' do
		it 'anon user, assigns locals appropriately' do
			get :show, id: @prp.id
			expect( assigns(:prp_owner_signed_in) ).to eq(false)
			expect( assigns(:rider) ).to eq(@prp)
			expect( assigns(:years_registration)).to eq(@prp.rider_year_registrations.last)
			expect( assigns(:donations)).to eq(@prp.rider_year_registrations.last.donations)
			expect( assigns(:raised)).to eq(@prp.rider_year_registrations.last.raised)
			expect( assigns(:percent_of_goal)).to eq(@prp.rider_year_registrations.last.percent_of_goal)
			expect( assigns(:goal)).to eq(@prp.rider_year_registrations.last.goal)
		end

		it 'prp-owner signs in, assigns locals appropriately, shows edit link', :sign_in_prp_owner do
			get :show, id: @prp.id	
			expect( assigns(:prp_owner_signed_in) ).to eq(true)
			expect( assigns(:rider) ).to eq(@prp)
			
		end
	end

	context 'index' do
		it 'renders all prps for current ride year', :multi_year_prps do

			get :index
			this_years_riders = RideYear.current.rider_year_registrations.map{|ryr| ryr.persistent_rider_profile}.keep_if{|p| p != nil }
			expect( assigns(:riders) ).to eq(this_years_riders)
			expect( assigns(:riders) ).not_to include(@p_old)
			expect( assigns(:year)).to eq(RideYear.current)
		end
	end

	context 'edit' do
		it 'renders form for logged in prp-owner', :sign_in_prp_owner do

			get :edit, id: @prp.id
			expect( assigns(:prp) ).to eq(@prp)
			expect( assigns(:this_years_registration) ).to eq(@prp.rider_year_registrations.find_by(ride_year: RideYear.current ))
			expect( assigns(:mailing_addresses)).to eq(@prp.mailing_addresses)
		end
	end

	context 'update' do
		it 'all valid fields, updates to db', :sign_in_prp_owner do
			up_params = {
				:id => @prp.id,
				:persistent_rider_profile => 
				{
					:bio => "updating my entry", 
					:primary_phone => '0987654321',
					:secondary_phone => '0987654321',
					:rider_year_registration => 
						{
							:goal => 5000
						}
					}	
				}

			put :update, up_params
			# must renew from db to see changes
			@prp = PersistentRiderProfile.find(@prp.id,)
		
      expect(response).to redirect_to(persistent_rider_profile_path(@prp))
			expect( @prp.bio ).to eq("updating my entry")
			expect( @prp.rider_year_registrations.last.goal ).to eq(5000)
		end

		it 'invalid prp, re-renders w errors', :sign_in_prp_owner do
			up_params = {
				:id => @prp.id,
				:persistent_rider_profile => 
				{
					:bio => "updating my entry", 
					:primary_phone => nil,
					:secondary_phone => '0987654321',
					:rider_year_registration => 
						{
							:goal => 5000
					}
				}	
			}
			put :update, up_params
			# must renew from db to see changes
			@prp = PersistentRiderProfile.find(@prp.id,)
		
      expect(response).to render_template(:edit)
      expect( assigns(:errors)).to_not be_empty
			# expect( @prp.bio ).to eq("updating my entry")
			# expect( @prp.rider_year_registrations.last.goal ).to eq(5000)
		end

		it 'invalid ryr, re-renders w errors', :sign_in_prp_owner do
			up_params = {
				:id => @prp.id,
				:persistent_rider_profile => 
				{
					:bio => "updating my entry", 
					:rider_year_registration => 
					{
							:goal => 3
					}
				}	
			}
			put :update, up_params
			# must renew from db to see changes
			@prp = PersistentRiderProfile.find(@prp.id,)
		
      expect(response).to render_template(:edit)
      expect( assigns(:errors)).to_not be_empty
		end
		it 'all invalid, re-renders w errors', :sign_in_prp_owner do
			up_params = {
				:id => @prp.id,
				:persistent_rider_profile => 
				{
					:primary_phone => nil, 
					:rider_year_registration => 
					{
							:goal => 3
					}
				}	
			}
			put :update, up_params
			# must renew from db to see changes
			@prp = PersistentRiderProfile.find(@prp.id,)
		
      expect(response).to render_template(:edit)
      expect( assigns(:errors)).to_not be_empty
		end
	end


end
