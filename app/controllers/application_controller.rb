class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # list admin authenticate first 
  before_action :authenticate_admin!, :authenticate_user!


  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_if_public_site_is_not_active
    redirect_to site_is_not_active_path if RideYear.current.disable_public_site
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:title, :first_name, :last_name, :email, :password, :password_confirmation) }
  end

end
