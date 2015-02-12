class RiderYearRegistrationsController < ApplicationController
	skip_before_action :authenticate_admin!
	# skip_before_action :authenticate_user!, only: [:new, :create]

	def new 
		## assume never registered before - brand new 
		@ryr = RiderYearRegistration.new
		@ryr.build_user
		@ryr.mailing_addresses.build
		@ryr.user.build_persistent_rider_profile
	end

	def create 
		p "#"*80
		p 'these be params'
		p "#{params.inspect}"
		p "#"*80

		p "#"*80
		p 'these be processed ryr_params'
		p "#{ryr_params.inspect}"
		p "#"*80

		@ryr = RiderYearRegistration.new(user: current_user)
		if @ryr.update_attributes(ryr_params)

			p "#"*80
			p 'ryr'
			p "#{@ryr.inspect}"
			p "#"*80
		else 
			p "#{ @ryr.errors.full_messages.to_sentence.inspect}" 
			p "#"*80
			p 'ryr errors'
			p "#{@ryr.errors }"
			p "#"*80
			@ryr.build_user
			@ryr.mailing_addresses.build(mailing_addess_params)
			@ryr.user.build_persistent_rider_profile(per_params)
			@errors = @ryr.errors
			render :new
			# redirect_to new_rider_year_registration_path, :flash => { :errors => @ryr.errors }
		end

			# p "#"*80
			# p 'ryr'
			# p "#{@ryr.inspect}"
			# p "#"*80

	end

	private 

	def ryr_params
    params.require(:rider_year_registration).permit(:ride_option, :goal, 
    	:mailing_addresses_attributes => [
    			:line_1, :line_2, :city, :state, :zip
    		],
    	:persistent_rider_profile_attributes => [
    			:primary_phone, :secondary_phone, :birthdate, :bio
    		] )
  end

  def mailing_addess_params
  	ryr_params[:mailing_address_attributes]
  end

  def per_params
  	ryr_params[:persistent_rider_profile_attributes]
  end


end
