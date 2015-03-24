class MailingAddressesController < ApplicationController
	skip_before_action :authenticate_admin!
	# skip_before_action :authenticate_user!, only: [:show, :index]
	before_action :validate_user_w_associated_m_a, except: [ :new, :create ]
	
	def new
		@m_a = MailingAddress.new
	end

	private

	def validate_user_w_associated_prp
    @m_a = MailingAddress.find(params[:id])
    unless @prp.user == current_user
      flash[:alert] = "Please log in to your own account to edit your profile."
      redirect_to root_path
    end
  end

end
