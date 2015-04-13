class Admin::MailingAddressesController < ApplicationController

	skip_before_action :authenticate_user!
	layout "admins"

	def new
		@user = User.find(params[:user_id])
		@m_a = MailingAddress.new
	end

	def create
		@user = User.find(params[:user_id])
		@m_a  = @user.mailing_addresses.build(m_a_params)
		if @m_a.save
			redirect_to admin_user_path(@user)
		else
			# @errors = @m_a.errors
			render 'new'
		end
	end

	def destroy
		@m_a = MailingAddress.find(params[:id])
		@user = @m_a.user
		if @user.mailing_addresses.count > 1
			@m_a.destroy
		else
			flash[:alert] = 'User must have at least one mailing address on file. Add a new one before deleting the old.'
		end
		redirect_to admin_user_path(@user)
	end

	def edit
		@m_a = MailingAddress.find(params[:id])
		@user = @m_a.user
	end

	def update
		# @user = User.find(params[:user_id])
		@m_a = MailingAddress.find(params[:id])
		@user = @m_a.user
		if @m_a.update_attributes(m_a_params)
			redirect_to admin_user_path(@user)
		else
			@errors = @m_a.errors
			render 'edit'
		end
	end

	private 
	def m_a_params
    params.require(:mailing_address).permit(
  		:line_1, :line_2, :city, :state, :zip, :id
    )
  end
end
