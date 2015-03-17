class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # list admin authenticate first 
  before_action :authenticate_admin!, :authenticate_user!


  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:title, :first_name, :last_name, :email, :password, :password_confirmation) }
  end

  def cc_info
    unless full_params['cc_type'] && full_params['cc_number'] && full_params['cc_expire_month'] && full_params['cc_expire_year(1i)'] && full_params['cc_cvv2']
      return false
    end
    {
      'type' => full_params['cc_type'],
      'number' => full_params['cc_number'],
      'expire_month' => full_params['cc_expire_month'],
      'expire_year' => full_params['cc_expire_year(1i)'],
      'cvv2' => full_params['cc_cvv2']
    }
  end

end
