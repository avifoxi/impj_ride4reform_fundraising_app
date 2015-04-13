class MailingAddressesController < ApplicationController
	# if current_user
	skip_before_action :authenticate_admin!#, :authenticate_user!
	# before_action :ensure_admin_or_user
	before_action :validate_user_w_associated_m_a, except: [ :new, :create ]
	# end
	# def ensure_user_or_admin
	# 	if current_user
	# 		puts 'got a user'
	# 	elsif current_admin
	# 		puts 'got a damnin'
	# 	end
	# end
	
	
	
	def new
		@m_a = MailingAddress.new
	end

	def create
		@m_a  = current_user.mailing_addresses.build(m_a_params)
		if @m_a.save
			redirect_to edit_persistent_rider_profile_path(current_user.persistent_rider_profile)
		else
			@errors = @m_a.errors
			render 'new'
		end
	end

	def destroy
		if current_user.mailing_addresses.count > 1
			@m_a = MailingAddress.find(params[:id])
			@m_a.destroy
		else
			flash[:alert] = 'You must have at least one mailing address on file. Add a new one before deleting the old.'
		end
		redirect_to edit_persistent_rider_profile_path(current_user.persistent_rider_profile)
	end

	def edit
		@m_a = MailingAddress.find(params[:id])
	end

	def update
		@m_a = MailingAddress.find(params[:id])
		if @m_a.update_attributes(m_a_params)
			redirect_to edit_persistent_rider_profile_path(current_user.persistent_rider_profile)
		else
			@errors = @m_a.errors
			render 'edit'
		end
	end

	private

	def validate_user_w_associated_m_a
    @m_a = MailingAddress.find(params[:id])
    unless @m_a.user == current_user
      flash[:alert] = "Please log in to your own account to edit your profile."
      redirect_to root_path
    end
  end

  def m_a_params
    params.require(:mailing_address).permit(
  		:line_1, :line_2, :city, :state, :zip, :id
    )
  end

end
